using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.UI;
using UnityEngine.Events;
using System.IO;

namespace Dialogue.Testing {
	public class YarnPathField : MonoBehaviour {
		[SerializeField] private InputField field;
		[SerializeField] private string prefsPathKey = "Last Yarn Path";
		[SerializeField] private string desiredExtension = ".yarn";

		[Tooltip("Note that this new value is saved from playerprefs automatically.")]
		[SerializeField] private UnityEvent onValid;
		[Tooltip("String value contains error message. Invoked with an empty string if no path.")]
		[SerializeField] private StringEvent onInvalid;

		private void Awake() {
			Assert.IsNotNull(field);
		}

		private void Start() {
			if(PlayerPrefs.HasKey(prefsPathKey)) {
				field.text = PlayerPrefs.GetString(prefsPathKey);
			}
			else {
				onInvalid.Invoke("");
			}
		}

		public void ValidatePath() {
			if (string.IsNullOrEmpty(field.text)) {
				onInvalid.Invoke("");
			}
			if (!File.Exists(field.text)) {
				onInvalid.Invoke("File doesn't exist!");
			}
			else if(Path.GetExtension(field.text) != desiredExtension) {
				onInvalid.Invoke("Must put a Yarn file!");
			}
			else {
				PlayerPrefs.SetString(prefsPathKey, field.text);
				PlayerPrefs.Save();

				onValid.Invoke();
			}
		}
	}
}
