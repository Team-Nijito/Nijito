using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dialogue.VN {
	public class TextureRenderer : MonoBehaviour {

		[SerializeField] private Camera cam;

		//private static Dictionary<string, RenderTexture> _textures;

		public RenderTexture PerformRender() {

			//RenderTexture newTex = new RenderTexture(1000, 1000, 0, RenderTextureFormat.ARGB32);
			RenderTexture newTex = new RenderTexture(Screen.width, Screen.height*2, 0, RenderTextureFormat.ARGB32);

			cam.targetTexture = newTex;
			cam.Render();
			cam.targetTexture = null;

			return newTex;
		}

	}
}
