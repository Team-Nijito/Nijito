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
			Settings.selectedYarn = yarn;
			//Settings.returnSceneIndex = SceneManager.GetActiveScene().buildIndex;
			Settings.onFinish = () => {
				Settings.selectedYarn = null;
				SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
			};
			SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
		}
	}
}
