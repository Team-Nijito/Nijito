using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dialogue {
	public class ScriptSelector
	{
		private const string YarnPath = "Yarns/";
		public static YarnProgram selectedYP { get; set; }

		public static void FromName(string ypName) {
			selectedYP = Resources.Load(YarnPath + ypName) as YarnProgram;
		}
	}
}
