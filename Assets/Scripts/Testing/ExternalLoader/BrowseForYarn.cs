using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using SFB;

namespace Dialogue.Testing {
	[System.Serializable]
	public class StringEvent : UnityEvent<string> {
	}

	public class BrowseForYarn : MonoBehaviour {
		[SerializeField] private StringEvent onPick;

		public void Activate() {
			var extensions = new[] { new ExtensionFilter("Yarn Files", "yarn") };
			var paths = StandaloneFileBrowser.OpenFilePanel("Open Yarn", "", extensions, false);

			if (paths.Length > 0) {
				onPick.Invoke(paths[0]);
			}
		}

	}
}
