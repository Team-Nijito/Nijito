using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Dialogue.Testing {
	public class SceneSwitcher : MonoBehaviour {
		[SerializeField] private int index;

		public void Activate() {
			SceneManager.LoadScene(index);
		}
	}
}
