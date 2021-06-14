using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using SimpleFileBrowser;

namespace Dialogue.Testing {
	[System.Serializable]
	public class StringEvent : UnityEvent<string> {
	}

	public class BrowseForYarn : MonoBehaviour {
		[SerializeField] private StringEvent onPick;
		[SerializeField] private UnityEvent onCancel;

		public void Activate() {

			FileBrowser.ShowLoadDialog(
				onSuccess: paths => onPick.Invoke(paths[0]),
				onCancel: () => onCancel.Invoke(),
				pickMode: FileBrowser.PickMode.Files
			);

		}

	}
}
