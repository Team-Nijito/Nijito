using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

namespace Dialogue.Testing {
	public class ScriptButtonCreator : MonoBehaviour {
		[SerializeField] private GameObject buttonPrefab;
		[SerializeField] private Transform buttonContainer;

		private void Awake() {
			Assert.IsNotNull(buttonPrefab);
			Assert.IsNotNull(buttonPrefab.GetComponent<ScriptButton>());
		}

		private void Start() {
			//Object[] yarns = Resources.LoadAll(ScriptSelector.YarnPath, typeof(YarnProgram));

			foreach(var y in ScriptSelector.allYarns) {
				GameObject newButton = Instantiate(buttonPrefab, buttonContainer) as GameObject;
				newButton.GetComponent<ScriptButton>().Configure(y);
			}
		}
	}
}
