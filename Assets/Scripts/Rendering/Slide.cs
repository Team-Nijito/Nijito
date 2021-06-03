using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

namespace Dialogue.Rendering {

	/// <summary>
	/// This contains the art for one character/thing which will be rendered by
	/// whichever SlideRenderer is in charge of this slide.
	/// 
	/// Use a reference to tex to access the render of the slide.
	///
	/// Make sure to call Configure when this component is created.
	/// </summary>
	public class Slide : MonoBehaviour {

		public const string DefaultEmoteName = "None";

		[SerializeField] private Transform emoteParent;
		[SerializeField] private GameObject defaultEmote;

		/// <summary>
		/// Render texture associated with this slide.
		/// </summary>
		public RenderTexture tex { get; private set; }
		private SlideRenderer sr;
		private bool configured = false;

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

		/// <summary>
		/// Does initial setup of the slide.
		/// </summary>
		/// <param name="tex">Texture associated with this slide.</param>
		/// <param name="sr">SlideRenderer which will be in charge of rendering.</param>
		public void Configure(SlideRenderer sr, RenderTexture tex) {
			Assert.IsFalse(configured, "Should only be configuring once!");

			this.tex = tex;
			this.sr = sr;
			configured = true;
		}

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

		private void Start() {
			Assert.IsNotNull(sr,
				"Slides shouldn't be instantiated directly, "
				+ "and instead should be controlled by a " + typeof(SlideRenderer).FullName
				+ "\n(If this is the case, make sure Configure is being called.)"
			);
		}

		/// <summary>
		/// Instructs the associated slide renderer to redraw this slide.
		/// </summary>
		public void Redraw() {
			sr.Redraw(this);
		}

		/// <summary>
		/// Attempts to switch to the given emote (i.e. face).
		///
		/// This causes a redraw.
		/// 
		/// If the name matches DefaultEmoteName,
		/// then it reverts back to the default emote.
		/// </summary>
		/// <param name="emoteName">Name of the emote to switch to.</param>
		public void SetEmote(string emoteName = DefaultEmoteName) {
			GameObject nextEmote = defaultEmote;

			if (emoteName != DefaultEmoteName && !emotes.TryGetValue(emoteName, out nextEmote)) {
				Debug.LogWarning(gameObject.name + " does not have an emote called " + emoteName);
				nextEmote = defaultEmote; // TryGetValue seems to null it out?
			}

			CurrentEmote = nextEmote;
			Redraw();
		}
	}
}
