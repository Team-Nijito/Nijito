using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Assertions;
using System;

namespace Dialogue.VN {
	public class Puppet : MonoBehaviour
	{
		public enum Facing { Left, Right }

		/// <summary>
		/// This is a group of puppets which will be moved by this puppet.
		/// </summary>
		public struct MoveBatch {

			public enum BatchMode { Push, Pull };

			public Speed moveSpeed 
				{ get; private set; }
			public StagePoint destination
				{ get; private set; }
			public BatchMode mode
				{ get; private set; }

			private List<Puppet> _targets;
			public Puppet[] targets {
				get         => _targets.ToArray();
				private set => _targets = new List<Puppet>(value);
			}

			public MoveBatch(Puppet[] targets, StagePoint destination, Speed moveSpeed, BatchMode mode) {

				this.moveSpeed = moveSpeed;
				this.destination = destination;
				this.mode = mode;

				// Necessary? Yes. Stupid? Definitely.
				_targets = null;

				// This must come after all fields are initialized; otherwise, VS complains.
				this.targets = targets ?? throw new ArgumentNullException(nameof(targets));
			}

			public void RemoveTarget(Puppet target) {
				_targets.Remove(target);
			}

			public override bool Equals(object obj) {
				return base.Equals(obj);
			}

			public override int GetHashCode() {
				return base.GetHashCode();
			}

			public override string ToString() {
				string result = "(";

				foreach(Puppet target in targets) {
					result += target.name;
				}

				result += ") going to " + destination?.name;
				return result;
			}
		}

		// TODO: Allow movement curve?
		// https://answers.unity.com/questions/1207389/can-animation-curves-be-used-to-control-variables.html

		public Image imageRenderer;
		public Facing initialFacing = Facing.Left;

		[Header("Movement")]
		[Range(0, 2)] public float maxSpeed = 0.6f;
		[Range(0, 2)] public float minSpeed = 0.05f;
		[Range(0, 2)] public float accelerationDistance = 0.2f;
		public AnimationCurve accelerationCurve = AnimationCurve.Linear(0f, 0f, 1f, 1f);
		[Range(0, 2)] public float decelerationDistance = 0.2f;
		public AnimationCurve decelerationCurve = AnimationCurve.Linear(0f, 0f, 1f, 1f);
		public float stoppingThreshold = 0.001f;
		[Tooltip("Range used for pushing and pulling.")]
		[Range(0f, 1f)]
		public float width = 0.1f;

		[Header("Animations")]
		public Animator animator;
		public string initialAnim = "None";
		public string fadeInAnim = "FadeIn";
		public string fadeOutAnim = "FadeOut";

		[Space(10)]
		public string speedControl = "speed";
		public float normalAnimationSpeed = 1f;
		public float quickAnimationSpeed = 2f;
		public float slowAnimationSpeed = 0.5f;
		public float nowAnimationSpeed = 1000f;


		// TODO This should be deleted and we should use characters instead.
		public Texture[] textures;

		private RectTransform rTransform;

		private StagePoint _destPoint;
		private StagePoint DestinationPoint {
			get {
				return _destPoint;
			}
			set {
				_destPoint?.RemoveInhabitant(gameObject);
				_destPoint = value;
				_destPoint?.AddInhabitant(gameObject, CurrentPosition);
			}
		}

		/// <summary>
		/// Currently active movement batches, used currently for pushing and pulling.
		/// 
		/// Never make this null; make it an empty list.
		/// </summary>
		private List<MoveBatch> currentBatches = new List<MoveBatch>();

		private Vector2 PreviousPosition {
			get; set;
		}
		private Vector2 CurrentPosition {
			get => rTransform.anchorMin;
		}

		/// <summary>
		/// This is all of the available animations.
		/// We could just use the Play method,
		/// but this allows us to do things in a case-insensitve way.
		/// </summary>
		[Obsolete]
		private string[] animationNames;

		/// <summary>
		/// Sets a new destination where we want to slide to.
		/// </summary>
		/// <param name="point">Point to move to.</param>
		/// <param name="batches">Set of movement batches for this next move. (Used for pushing and pulling, mostly.)</param>
		public void SetMovementDestination(StagePoint point, List<MoveBatch> batches = null) {
			this.DestinationPoint = point;
			PreviousPosition = CurrentPosition;

			if(batches != null) {
				string output = "batch:";
				foreach(MoveBatch batch in batches) {
					output += "\n" + batch.ToString();
				}
				//Debug.Log(output);
			}

			if (batches != null) {
				currentBatches = batches;
			}
			else {
				currentBatches.Clear();
			}
        }

		/// <summary>
		/// Snap to the given position.
		/// This also cancels out any movement.
		/// </summary>
		public void Warp(StagePoint point) {
			SetMovementDestination(point);
			SetPosition(DestinationPoint.GetPosition(gameObject).x);
			
			PreviousPosition = CurrentPosition;
        }

		public void SetFacing(Facing newFacing)
		{
			Vector3 s = rTransform.localScale;
			s.x = (newFacing == initialFacing ? 1 : -1);
			rTransform.localScale = s;
			/*
			Rect uvRect = imageRenderer.uvRect;
			uvRect.width = (newFacing == defaultFacing ? 1 : -1);
			imageRenderer.uvRect = uvRect;
			*/
		}

		public void FocusSelf() {
			int siblingCount = transform.parent.childCount;
			transform.SetSiblingIndex(siblingCount - 1);
		}


		public void SetTexture(int index)
		{
			//imageRenderer.texture = textures[index];
		}

		public void PlayAnim(string name, Speed speed = Speed.Normal, Action onComplete = null) {

			/*
			string stateName = string.IsNullOrEmpty(name)
				? initialAnim
				: animationNames.FirstOrDefault(n => name.Equals(n, StringComparison.OrdinalIgnoreCase));

			if (stateName == default(string)) {
				Debug.LogWarning("Could not find animation named " + name);
				stateName = initialAnim;
			}
			*/

			float speedScale;
			switch (speed) {
				default:
					Debug.LogWarning("Unsupported animation speed: " + speed);
					goto case Speed.Normal;
				case Speed.Normal: speedScale = normalAnimationSpeed; break;
				case Speed.Quick:  speedScale = quickAnimationSpeed; break;
				case Speed.Slow:   speedScale = slowAnimationSpeed; break;
				case Speed.Now:    speedScale = nowAnimationSpeed; break;
			}

			animator.SetFloat(speedControl, speedScale);
			animator.Play(name);

			if (onComplete != null) {
				StartCoroutine(WaitForAnim(onComplete));
			}
		}

		public void FadeIn(Speed speed, Action onComplete = null) {
			PlayAnim(fadeInAnim, speed, onComplete);
		}

		public void FadeOut(Speed speed, Action onComplete = null) {
			PlayAnim(fadeOutAnim, speed, onComplete + (() => DestinationPoint = null));
		}

		private IEnumerator WaitForAnim(System.Action onComplete) {
			// This works even for loops; the time counts on from 1 even after first loop

			yield return new WaitForEndOfFrame(); // Wait for the animation to start playing
			yield return new WaitUntil(() =>
				animator.GetCurrentAnimatorStateInfo(0).normalizedTime >= 1
			);
			onComplete();
		}

		private void SetPosition(float newHorizontalPos)
		{
			rTransform.anchorMin = new Vector2(newHorizontalPos, rTransform.anchorMin.y);
			rTransform.anchorMax = new Vector2(newHorizontalPos, rTransform.anchorMax.y);
		}

		private void Awake()
		{
			//animationNames = animator.runtimeAnimatorController.animationClips.Select(c => c.name).ToArray();

			rTransform = GetComponent<RectTransform>();
			Assert.IsNotNull(rTransform,
				"Puppets should be part of the UI, not in the scene itself!"
			);
			Assert.IsNotNull(imageRenderer, "Puppets must have a RawImage!");
			Assert.IsNotNull(animator, "Puppet needs an animator");
		}

		private void Update()
		{
			if (DestinationPoint != null) {
				float destinationPosition = DestinationPoint.GetPosition(gameObject).x;

				//if (!Mathf.Approximately(CurrentPosition.x, horizontalPosition)) {
				if (Mathf.Abs(CurrentPosition.x - destinationPosition) > stoppingThreshold) {

					Vector2 oldPosition = CurrentPosition;

					/*
					SetPosition( Mathf.Lerp(
						CurrentPosition.x,
						destinationPosition,
						movementSpeed * Time.deltaTime
					) );
					*/

					SetPosition(Mathf.MoveTowards(
						CurrentPosition.x,
						destinationPosition,
						CalculateSpeed(
							PreviousPosition.x, destinationPosition, CurrentPosition.x,
							maxSpeed, minSpeed,
							accelerationDistance, accelerationCurve,
							decelerationDistance, decelerationCurve
						) * Time.deltaTime
					));



					Vector2 deltaPosition = CurrentPosition - oldPosition;
					float direction = Mathf.Sign(deltaPosition.x);
					float pushPoint = CurrentPosition.x + direction * width; // Front
					float pullPoint = CurrentPosition.x - direction * width; // Back

					foreach(MoveBatch batch in currentBatches) {
						float threshold = CurrentPosition.x;
						switch (batch.mode) {
							case MoveBatch.BatchMode.Push:
								threshold = pushPoint;
								break;
							case MoveBatch.BatchMode.Pull:
								threshold = pullPoint;
								break;
							default:
								Debug.LogWarning("Unhandled case");
								break;
						}

						// Save this because we'll be changing the source
						Puppet[] batchTargets = batch.targets;
						foreach(Puppet target in batchTargets) {
							bool passedThreshold =
								direction > 0 // Heading towards the right?
									? target.CurrentPosition.x < threshold  // Check if passed to the left
									: target.CurrentPosition.x > threshold; // Check if passed to the right

							if(passedThreshold) {
								// TODO check how this works when destination is same as current one
								//      i.e. batch destination is null
								target.SetMovementDestination(batch.destination ?? DestinationPoint);
								batch.RemoveTarget(target);
							}
						}
					}

				}
				else {
					currentBatches.Clear();
				}
			}
		}

		private static float CalculateSpeed(
			float startpoint, float endpoint, float position,
			float maxSpeed, float minSpeed,
			float accelerationDistance, AnimationCurve accelerationCurve,
			float decelerationDistance, AnimationCurve decelerationCurve
		) {

			// Velocity line is in shape of
			//
			// maxSpeed       ________
			//               /        \
			//              /          \
			// minSpeed ___/            \___
			//           left         right
			//
			// If start and end are sufficiently close,
			// then the slanted lines intersect,
			// and there is no plateau.
			//
			// All this means we have 4 possible velocities:
			//  1. maxSpeed
			//  2. leftRampSpeed
			//  3. rightRampSpeed
			//  4. minSpeed
			//
			// We'll pick it in this order:
			//  1. Calculate each ramp speed, pick the lesser
			//  2. If that's more than maxSpeed, use maxSpeed
			//  3. If that's less than minSpeed, use minSpeed
			//
			// These are speeds, no velocities.
			// Caller must determine direction.

			float maxDeltaSpeed = maxSpeed - minSpeed;

			bool startedOnLeft = startpoint < endpoint;

			//float leftPoint, leftSlope, rightPoint, rightSlope;
			float leftPoint, rightPoint, leftDist, rightDist;
			AnimationCurve leftCurve, rightCurve;
			if(startedOnLeft) {
				leftPoint = startpoint;
				leftDist = accelerationDistance;
				leftCurve = accelerationCurve;

				rightPoint = endpoint;
				rightDist = decelerationDistance;
				rightCurve = decelerationCurve;
			}
			else {
				leftPoint = endpoint;
				leftDist = decelerationDistance;
				leftCurve = decelerationCurve;

				rightPoint = startpoint;
				rightDist = accelerationDistance;
				rightCurve = accelerationCurve;
			}

			float leftRampSpeed =  Mathf.Clamp( leftCurve.Evaluate( (position - leftPoint) /leftDist),  minSpeed, maxSpeed);
			float rightRampSpeed = Mathf.Clamp(rightCurve.Evaluate(-(position - rightPoint)/rightDist), minSpeed, maxSpeed);

			float rampSpeed = Mathf.Min(leftRampSpeed, rightRampSpeed);
			float clampedSpeed = Mathf.Clamp( rampSpeed, minSpeed, maxSpeed );

			Debug.Log(startedOnLeft + " " + rampSpeed + " " + clampedSpeed);

			return clampedSpeed;
		}


	}
}
