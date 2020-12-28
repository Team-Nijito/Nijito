using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dialogue.VN {
	public class StagePoint : MonoBehaviour {

		[Tooltip("This is percentage of the screen width")]
		[Range(0, 1)]
		public float width = 0.3f;
		[Range(0, 1)]
		public float alignment = 0.5f;
		
		private List<GameObject> inhabitants;
		private RectTransform rt;

		private void Awake() {
			inhabitants = new List<GameObject>();
			rt = GetComponent<RectTransform>();
		}

		/// <summary>
		/// The center point. This never changes.
		/// </summary>
		public Vector2 Center {
			get => (rt.anchorMax + rt.anchorMin) / 2;
		}

		/// <summary>
		/// This is one of the most extreme positions a inhabiting object may take.
		/// </summary>
		private Vector2 StartPoint {
			get => Center - new Vector2(width / 2, 0);
		}

		/// <summary>
		/// Begins to assume that the given object will be residing at this point.
		/// 
		/// If the object is already an inhabitant, the order of the objects may change.
		/// </summary>
		/// <param name="obj">Objects to be registered.</param>
		/// <param name="objPosition">The object's pivot position.</param>
		public void AddInhabitant(GameObject obj, Vector2 objPosition) {
			inhabitants.Remove(obj);

			// TODO account for source's position.
			if (Center.x > objPosition.x)
				inhabitants.Insert(0, obj);
			else
				inhabitants.Add(obj);
		}

		/// <summary>
		/// Stop assuming that the given object wishes to reside at this point.
		/// 
		/// Nothing bad happens if object is not registered.
		/// </summary>
		/// <param name="obj">Registered object.</param>
		public void RemoveInhabitant(GameObject obj) {
			inhabitants.Remove(obj);
		}

		/// <summary>
		/// Gets the position which has been assigned to the given object.
		/// 
		/// Object should be registered as an inhabitant of the point before calling this.
		/// </summary>
		/// <param name="obj">Objects requesting a position.</param>
		/// <returns>The assigned position, or the centerpoint if the object is not been registered.</returns>
		public Vector2 GetPosition(GameObject obj) {
			Vector2 result;
			int index = inhabitants.IndexOf(obj);

			if (index == -1) {
				Debug.LogWarning(obj.name + " is requesting a position, but is not registered");
				result = Center;
			}
			else {
				// Logic is somewhat complex here... math works out though.
				// Essentially, we slice our width such that each inhabitant
				// gets a piece. Then we need to move each inhabitant so they
				// are in the middle of their slice.
				float slice = width / inhabitants.Count;
				float offset = slice * (index + alignment);
				result = StartPoint + new Vector2(offset, 0);
			}

			return result;
		}




	}
}
