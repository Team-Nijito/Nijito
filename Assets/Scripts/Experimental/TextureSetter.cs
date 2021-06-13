using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Nijito.Paperdoll;

namespace Dialogue.VN {
	public class TextureSetter : MonoBehaviour {
		[SerializeField] private Image imgRenderer;
		[SerializeField] private RawImage rawImgRenderer;
		[SerializeField] private SlideRenderer renderSource;
		//public RenderTexture texture;

		private List<RenderTexture> textures;

		private bool firstRun = true;
		private Slide trh;

		void OnEnable() {
			if(firstRun) {
				trh = renderSource.NewSlide("Ami", 100, 100);
				imgRenderer.material = new Material(imgRenderer.material);
				imgRenderer.material.mainTexture = trh.tex;

				firstRun = false;
			}

			//renderSource.RedrawTo(imgRenderer.material.mainTexture as RenderTexture);
			trh.Redraw();


		}

	}
}
