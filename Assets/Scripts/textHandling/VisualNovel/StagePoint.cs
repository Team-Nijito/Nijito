using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dialogue.VN {
    public class StagePoint : MonoBehaviour {
        private RectTransform rt;

        private void Awake() {
            rt = GetComponent<RectTransform>();
        }

        public Vector2 position {
            get => (rt.anchorMax + rt.anchorMin)/2;
        }
    }
}
