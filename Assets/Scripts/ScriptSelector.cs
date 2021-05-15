using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dialogue {
	public class ScriptSelector
	{
		private const string YarnPath = "Yarns/";
		public static YarnProgram selectedYP { get; set; }

		[System.Obsolete(
			"String-based references are risky and shouldn't be used without good reason." +
			"If you do have a good reason, remove the Obsolete attribute."
		)]
		public static void FromName(string ypName) {
			selectedYP = Resources.Load(YarnPath + ypName) as YarnProgram;
		}
	}
}
