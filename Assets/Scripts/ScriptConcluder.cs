using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Dialogue {
	public class ScriptConcluder : MonoBehaviour {
		public void LoadNextScene() {
			//Settings.selectedYarn = null;
			//SceneManager.LoadScene(Settings.returnSceneIndex);
			Settings.onFinish();
		}
	}
}
