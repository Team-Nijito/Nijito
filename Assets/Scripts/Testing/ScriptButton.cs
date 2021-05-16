using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

namespace Dialogue.Testing {
	public class ScriptButton : MonoBehaviour {

		[SerializeField] private Text label;

		private YarnProgram yarn;

		public void Configure(YarnProgram yarn) {
			this.yarn = yarn;
			label.text = yarn.name;
		}

		public void LoadScript() {
			ScriptSelector.selectedYarn = yarn;
			ScriptSelector.returnSceneIndex = SceneManager.GetActiveScene().buildIndex;
			SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
		}
	}
}
