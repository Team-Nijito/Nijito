using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dialogue.VN {
	public class StagePoint : MonoBehaviour {

		private List<GameObject> inhabitants;
		private RectTransform rt;

		private void Awake() {
			inhabitants = new List<GameObject>();
			rt = GetComponent<RectTransform>();
		}

		public void AddInhabitant(GameObject obj) {
			inhabitants.Remove(obj);
			inhabitants.Add(obj);
		}

		public void RemoveInhabitant(GameObject obj) {
			inhabitants.Remove(obj);
		}

		public Vector2 GetPosition(GameObject obj) {
			Vector2 result = Position;

			if(inhabitants.Contains(obj)) {
				Debug.LogWarning(obj.name + " is requesting a position, but is not registered");
			}

			return result;
		}
		public Vector2 Position {
			get => (rt.anchorMax + rt.anchorMin) / 2;
		}
	}
}
