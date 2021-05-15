using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dialogue {

	/// <summary>
	/// This class is used to track which script to load.
	/// </summary>
	public static class ScriptSelector
	{
		private const string YarnPath = "Yarns/";

		/// <summary>
		/// When the VN scene is loaded, this value is referenced.
		/// If this value is null, it's assumed we're in debugging
		/// or testing mode.
		/// </summary>
		public static YarnProgram selectedYarn { get; set; }

		[System.Obsolete(
			"String-based references are risky and shouldn't be used without good reason." +
			"If you do have a good reason, pragma this warning out."
		)]
		public static void FromName(string ypName) {
			selectedYarn = Resources.Load(YarnPath + ypName) as YarnProgram;
		}
	}
}
