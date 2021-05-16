using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Dialogue {
	public class ScriptConcluder : MonoBehaviour {
		public void LoadNextScene() {
			ScriptSelector.selectedYarn = null;
			SceneManager.LoadScene(ScriptSelector.returnSceneIndex);
		}
	}
}
