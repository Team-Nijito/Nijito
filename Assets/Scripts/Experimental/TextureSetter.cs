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

		private bool firstRun = true;
		private TextureRenderer.Handle trh;

		void OnEnable() {
			if(firstRun) {
				trh = renderSource.NewTexture("Ami", 100, 100);
				imgRenderer.material = new Material(imgRenderer.material);
				imgRenderer.material.mainTexture = trh.tex;

				firstRun = false;
			}

			//renderSource.RedrawTo(imgRenderer.material.mainTexture as RenderTexture);
			trh.Redraw();


		}

	}
}
