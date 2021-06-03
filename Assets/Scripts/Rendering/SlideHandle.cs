using UnityEngine;

namespace Dialogue.Rendering {

	[System.Obsolete("Use Slide instead")]
	public struct SlideHandle {
		private SlideRenderer renderer;
		private Slide slide;
		public RenderTexture tex { get; private set; }

		public SlideHandle(SlideRenderer renderer, Slide slide, RenderTexture tex) {
			this.renderer = renderer;
			this.slide = slide;
			this.tex = tex;

			slide.gameObject.SetActive(false);
		}

		[System.Obsolete]
		public void Redraw() {
			slide.gameObject.SetActive(true);
			renderer.Redraw(slide);
			slide.gameObject.SetActive(false);
		}

		[System.Obsolete]
		public void SetEmote(string emoteName) {
			slide.SetEmote(emoteName);
			Redraw();
		}
	}


}
