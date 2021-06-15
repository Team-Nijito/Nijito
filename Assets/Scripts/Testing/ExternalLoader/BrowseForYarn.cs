using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.UI;
using UnityEngine.Events;
using SimpleFileBrowser;

namespace Dialogue.Testing {
	public class BrowseForYarn : MonoBehaviour {
		// TODO This should probably switch to some form of dependency injection rather than using glue like this
		[Tooltip("This is ONLY used to read an initial path, and is not updated via code.")]
		[SerializeField] private InputField pathField;

		[SerializeField] private StringEvent onPick;
		[SerializeField] private UnityEvent onCancel;

		public void Awake() {
			Assert.IsNotNull(pathField);
		}

		public void Activate() {

			string initialPath = null;

			if (!string.IsNullOrEmpty(pathField.text)) {
				Path.GetDirectoryName(pathField.text);
			}

			FileBrowser.ShowLoadDialog(
				onSuccess: paths => onPick.Invoke(paths[0]),
				onCancel: () => onCancel.Invoke(),
				pickMode: FileBrowser.PickMode.Files,
				initialPath: initialPath
			);

		}

	}
}
