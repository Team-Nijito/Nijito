using System.Linq;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Yarn.Unity;

namespace Dialogue.VN {
	public class YarnScriptLoader : MonoBehaviour {
		public YarnProgram defaultScript;
		public DialogueRunner runner;

		void Start() {
			//ScriptSelector.FromName("TestScript"); // TODO Remove

			YarnProgram script = ScriptSelector.selectedYP ?? defaultScript;

			runner.Add(script);
			runner.StartDialogue(script.GetProgram().Nodes.First().Key);
		}

	}
}
