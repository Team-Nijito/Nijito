using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Dialogue.VN {
	public class TextureSetter : MonoBehaviour {
		[SerializeField] private Image imgRenderer;
		[SerializeField] private RawImage rawImgRenderer;
		[SerializeField] private TextureRenderer renderSource;
		//public RenderTexture texture;

		private List<RenderTexture> textures;

		void Start() {
			if (imgRenderer != null) {
				imgRenderer.material.mainTexture = renderSource.PerformRender();
			}
			if (rawImgRenderer != null) {
				rawImgRenderer.material.mainTexture = renderSource.PerformRender();
			}

			textures = new List<RenderTexture>();
			for(int i = 0; i < 10; i++) {
				textures.Add(renderSource.PerformRender());
			}
		}

	}
}
