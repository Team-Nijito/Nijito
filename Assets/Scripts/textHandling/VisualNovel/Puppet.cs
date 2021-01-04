using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Assertions;
using System;

namespace Dialogue.VN
{
	public class Puppet : MonoBehaviour
	{
		public enum Facing { Left, Right }
		public enum Speed { Normal, Now, Quick, Slow }

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
		public float movementSpeed = 5f;
		public float stoppingDistance = 0.01f;
		[Tooltip("Range used for pushing and pulling.")]
		[Range(0f, 1f)]
		public float width = 0.1f;
		public Facing initialFacing = Facing.Left;

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

		private Vector2 CurrentPosition {
			get => rTransform.anchorMin;
		}

		/// <summary>
		/// Sets a new destination where we want to slide to.
		/// </summary>
		/// <param name="point">Point to move to.</param>
		public void SetMovementDestination(StagePoint point, List<MoveBatch> batches = null) {
			this.DestinationPoint = point;

			if(batches != null) {
				string output = "batch:";
				foreach(MoveBatch batch in batches) {
					output += "\n" + batch.ToString();
				}
				Debug.Log(output);
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

		private void SetPosition(float newHorizontalPos)
		{
			rTransform.anchorMin = new Vector2(newHorizontalPos, rTransform.anchorMin.y);
			rTransform.anchorMax = new Vector2(newHorizontalPos, rTransform.anchorMax.y);
		}

		private void Awake()
		{
			rTransform = GetComponent<RectTransform>();
			Assert.IsNotNull(rTransform, "Puppets should be part of the UI, not in the scene itself!");
			Assert.IsNotNull(imageRenderer, "Puppets must have a RawImage!");
			
		}

		private void Update()
		{
			if (DestinationPoint != null) {
				float destinationPosition = DestinationPoint.GetPosition(gameObject).x;

				//if (!Mathf.Approximately(CurrentPosition.x, horizontalPosition)) {
				if (Mathf.Abs(CurrentPosition.x - destinationPosition) > stoppingDistance) {

					Vector2 oldPosition = CurrentPosition;

					SetPosition( Mathf.Lerp(
						CurrentPosition.x,
						destinationPosition,
						movementSpeed * Time.deltaTime
					) );

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


	}
}
