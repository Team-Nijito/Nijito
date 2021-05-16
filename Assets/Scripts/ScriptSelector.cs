using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

namespace Dialogue {

	/// <summary>
	/// This class is used to track which script to load for the VN system.
	/// </summary>
	public static class ScriptSelector
	{
		/// <summary>
		/// Location yarns are stored. This path is checked when looking
		/// for all yarns in the project.
		/// </summary>
		public const string YarnPath = "Yarns/";

		/// <summary>
		/// When the VN scene is loaded, this is the script to get loaded.
		/// If this value is null, it's assumed we're in a testing mode.
		////
		/// This behavior MAY CHANGE in full builds to show an error
		/// message instead.
		/// </summary>
		public static YarnProgram selectedYarn { get; set; }

		/// <summary>
		/// When the VN script concludes, this is the index of the scene
		/// that gets loaded.
		/// </summary>
		public static int returnSceneIndex { get; set; }

		/// <summary>
		/// Sets a Yarn based on is name.
		/// </summary>
		/// <param name="ypName">Yarn's name in the format of "TestScene".</param>
		[System.Obsolete(
			"String-based references are risky and shouldn't be used without good reason." +
			"If you do have a good reason, pragma this warning out."
		)]
		public static void FromName(string ypName) {
			selectedYarn = Resources.Load(YarnPath + ypName) as YarnProgram;
		}

		/// <summary>
		/// Gets all yarns in the resources.
		/// Note that this will load ALL of them ONCE.
		/// The list is cached after the first load.
		/// </summary>
		public static YarnProgram[] allYarns {
			get {
				if(_allYarns == null) {
					Object[] yarns = Resources.LoadAll(YarnPath, typeof(YarnProgram));
					_allYarns = yarns.Cast<YarnProgram>().ToArray();
				}

				return _allYarns;
			}
		}
		private static YarnProgram[] _allYarns;

	}
}
