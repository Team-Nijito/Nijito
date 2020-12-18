using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Assertions;

namespace Dialogue.VN
{
	public class Puppet : MonoBehaviour
	{
		public enum Facing
		{
			Left,
			Right
		}

		// TODO: Allow movement curve?
		// https://answers.unity.com/questions/1207389/can-animation-curves-be-used-to-control-variables.html

		public Image imageRenderer;
		public float movementSpeed = 5f;
		public Facing initialFacing = Facing.Left;

		// TODO This should be deleted and we should use characters instead.
		public Texture[] textures;

		private RectTransform rTransform;

		private StagePoint _point;
		private StagePoint Point {
			get {
				return _point;
			}
			set {
				_point?.RemoveInhabitant(gameObject);
				_point = value;
				_point?.AddInhabitant(gameObject, CurrentPosition);
			}
		}

		private Vector2 CurrentPosition {
			get => rTransform.anchorMin;
		}

		/// <summary>
		/// Sets a new destination where we want to slide to.
		/// </summary>
		/// <param name="point">Point to move to.</param>
		public void SetMovementDestination(StagePoint point) {
			this.Point = point;
        }

		/// <summary>
		/// Snap to the given position.
		/// This also cancels out any movement.
		/// </summary>
		public void Warp(StagePoint point) {
			SetMovementDestination(point);
			SetPosition(Point.GetPosition(gameObject).x);
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
			if (Point != null) {
				float horizontalPosition = Point.GetPosition(gameObject).x;

				if (!Mathf.Approximately(CurrentPosition.x, horizontalPosition)) {

					SetPosition( Mathf.Lerp(
						CurrentPosition.x,
						horizontalPosition,
						movementSpeed * Time.deltaTime
					) );
				}
			}
		}


	}
}
