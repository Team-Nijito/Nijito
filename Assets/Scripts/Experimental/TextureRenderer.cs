using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

namespace Dialogue.VN {
	public class TextureRenderer : MonoBehaviour {

		public struct Handle {
			private TextureRenderer renderer;
			private GameObject slide; // Contains all of the layers to be rendered
			private Dictionary<string, List<GameObject>> slideLayers;
			public RenderTexture tex { get; private set; }

			public Handle(TextureRenderer renderer, GameObject slide, RenderTexture tex) {
				this.renderer = renderer;
				this.slide = slide;
				this.tex = tex;

				slide.SetActive(false);

				slideLayers = new Dictionary<string, List<GameObject>>();
				// TODO Write slide layers
				/*
				foreach(Transform layer in slide.transform) {

				}
				*/
			}

			public void Redraw() {
				slide.SetActive(true);
				renderer.RedrawTo(tex);
				slide.SetActive(false);
			}
		}

		[SerializeField] private string puppetPrefabPath = "PuppetRenderers";
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

			GameObject prefab = Resources.Load(puppetPrefabPath + "/" + name) as GameObject;
			GameObject slide = Instantiate(prefab, slideParent);

			return new Handle(this, slide, newTex);
		}

		private void Awake() {
			Assert.IsNotNull(cam);
			Assert.IsNotNull(slideParent);
		}


	}
}
