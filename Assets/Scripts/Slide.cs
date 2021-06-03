using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dialogue.VN {
	public class Slide : MonoBehaviour {

		private const string DefaultEmoteName = "None";

		[SerializeField] private Transform emoteParent;
		[SerializeField] private GameObject defaultEmote;

		private GameObject _currentEmote;
		private GameObject CurrentEmote {
			get {
				return _currentEmote;
			}
			set {
				if (_currentEmote != value) {
					if (_currentEmote != null) {
						_currentEmote.SetActive(false);
					}
					_currentEmote = value;
					if (_currentEmote != null) {
						_currentEmote.SetActive(true);
					}
				}
			}
		}

		private Dictionary<string, GameObject> emotes;

		private void Awake() {
			emotes = new Dictionary<string, GameObject>();
			if (emoteParent != null) {
				foreach (Transform child in emoteParent) {
					emotes[child.name] = child.gameObject;

					// Just in case setup got something wrong... yeah we'll turn things off
					if (child.gameObject != defaultEmote) {
						child.gameObject.SetActive(false);
					}
				}
			}
			else {
				Debug.LogWarning(gameObject.name + " does not have any emotes!");
			}
		}

		public void SetEmote(string emoteName) {
			GameObject nextEmote = defaultEmote;

			if(emoteName != DefaultEmoteName && !emotes.TryGetValue(emoteName, out nextEmote)) {
				Debug.LogWarning(gameObject.name + " does not have an emote called " + emoteName);
				nextEmote = defaultEmote; // TryGetValue seems to null it out?
			}

			CurrentEmote = nextEmote;
		}
	}
}
