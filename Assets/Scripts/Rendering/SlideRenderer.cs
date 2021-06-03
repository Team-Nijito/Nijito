using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

namespace Dialogue.Rendering {

	/// <summary>
	/// Oversees slides, not just at rendering but also with creation.
	/// 
	/// Use this to get Slide objects. After that, work with the slide object
	/// directly. It will handle its interface with the renderer.
	/// </summary>
	public class SlideRenderer : MonoBehaviour {

		[SerializeField] private string slidePrefabPath = "Slides";
		[SerializeField] private Camera cam;
		[SerializeField] private RenderTextureFormat renderFormat = RenderTextureFormat.ARGB32;
		[SerializeField] private Transform slideParent;

		/// <summary>
		/// Redraws the given slide. This controls everything
		/// </summary>
		/// <param name="s">Slide to redraw.</param>
		public void Redraw(Slide s) {
			s.gameObject.SetActive(true);
			cam.targetTexture = s.tex;
			cam.Render();
			cam.targetTexture = null;
			s.gameObject.SetActive(false);
		}

		/// <summary>
		/// Creates a new slide based on the given name. If a slide with that name
		/// cannot be found, you'll get a Dio instead.
		/// </summary>
		/// <param name="name">Name of slide.</param>
		/// <param name="width">Width of the slide in pixels.</param>
		/// <param name="height">Height of the slide in pixels.</param>
		/// <returns>Reference to the new slide.</returns>
		public Slide NewSlide(string name, int width, int height) {

			// TODO This should get Dio if needed

			RenderTexture newTex = new RenderTexture(width, height, 0, renderFormat);

			GameObject prefab = Resources.Load(slidePrefabPath + "/" + name) as GameObject;
			GameObject slideObj = Instantiate(prefab, slideParent);
			slideObj.SetActive(false);

			Slide slide = slideObj.GetComponent<Slide>();
			Assert.IsNotNull(slide,
				"All slide objects inside resources/" + slidePrefabPath
				+ " should have the " + typeof(Slide).FullName + " component!"
			);
			slide.Configure(this, newTex);

			//return new SlideHandle(this, slide, newTex);
			return slide;
		}

		private void Awake() {
			Assert.IsNotNull(cam);
			Assert.IsNotNull(slideParent);
		}


	}
}
