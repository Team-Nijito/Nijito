using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

namespace Dialogue.VN {
	public class SlideRenderer : MonoBehaviour {

		public struct Handle {
			private SlideRenderer renderer;
			private Slide slide;
			public RenderTexture tex { get; private set; }

			public Handle(SlideRenderer renderer, Slide slide, RenderTexture tex) {
				this.renderer = renderer;
				this.slide = slide;
				this.tex = tex;

				slide.gameObject.SetActive(false);
			}

			public void Redraw() {
				slide.gameObject.SetActive(true);
				renderer.RedrawTo(tex);
				slide.gameObject.SetActive(false);
			}

			public void SetEmote(string emoteName) {
				slide.SetEmote(emoteName);
				Redraw();
			}
		}

		[SerializeField] private string slidePrefabPath = "Slides";
		[SerializeField] private Camera cam;
		[SerializeField] private RenderTextureFormat renderFormat = RenderTextureFormat.ARGB32;
		[SerializeField] private Transform slideParent;

		private Dictionary<string, RenderTexture> _textures;

		public void RedrawTo(RenderTexture tex) {
			cam.targetTexture = tex;
			cam.Render();
			cam.targetTexture = null;
		}

		public Handle NewTexture(string name, int width, int height) {
			//RenderTexture newTex = new RenderTexture( Screen.width*widthScale, Screen.height*heightScale, 0, renderFormat );
			RenderTexture newTex = new RenderTexture(width, height, 0, renderFormat );

			GameObject prefab = Resources.Load(slidePrefabPath + "/" + name) as GameObject;
			GameObject slideObj = Instantiate(prefab, slideParent);
			Slide slide = slideObj.GetComponent<Slide>();

			Assert.IsNotNull(slide, "All slide objects inside resources/" + slidePrefabPath + " should have the " + typeof(Slide).FullName + " component!");

			return new Handle(this, slide, newTex);
		}

		private void Awake() {
			Assert.IsNotNull(cam);
			Assert.IsNotNull(slideParent);
		}


	}
}
