using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.UI;

namespace Dialogue.Testing {
	public class BindButtonToKey : MonoBehaviour {
		[SerializeField] private Button button;
		[SerializeField] private KeyCode key;
		
		[Space(10)]
		[SerializeField] private bool useMod;
		[SerializeField] private KeyCode mod1 = KeyCode.LeftShift;
		[SerializeField] private KeyCode mod2 = KeyCode.RightShift;

		private void Awake() {
			Assert.IsNotNull(button);
		}

		private void Update() {
			if((!useMod || Input.GetKey(mod1) || Input.GetKey(mod2)) && Input.GetKeyDown(key) && button.IsInteractable()) {
				button.onClick.Invoke();
			}
		}
	}
}
