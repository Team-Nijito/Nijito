using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dialogue.Testing {
	public class ProgramCloser : MonoBehaviour {

		public void OnEnable() {
			//Debug.Log(GUIUtility.systemCopyBuffer);
			var txt = GetComponentInChildren<UnityEngine.UI.Text>();
			txt.text = GUIUtility.systemCopyBuffer;
		}

		public void Activate() {
			Application.Quit();
		}
	}
}
