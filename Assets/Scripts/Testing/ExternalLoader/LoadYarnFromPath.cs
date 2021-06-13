using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Assertions;
using Yarn.Compiler;
using UnityEngine.SceneManagement;
using System.IO;

namespace Dialogue.Testing {

	public class LoadYarnFromPath : MonoBehaviour {
		[SerializeField] private InputField pathSrc;
		[SerializeField] private int testSceneIndex;

		private void Awake() {
			Assert.IsNotNull(pathSrc);
		}

		public void Activate() {
			if(string.IsNullOrEmpty(pathSrc.text)) {
				Debug.LogWarning("Must have a Yarn to load!");
			}
			else {
				Yarn.Program compiledProgram;
				IDictionary<string, StringInfo> stringTable;
				string fileName = Path.GetFileNameWithoutExtension(pathSrc.text);

				//Settings.selectedYarn = program;
				Status compilationStatus;

				try {
					// Compile the source code into a compiled Yarn program (or
					// generate a parse error)
					compilationStatus = Compiler.CompileFile(pathSrc.text, out compiledProgram, out stringTable);

					// Create a container for storing the bytes
					YarnProgram programContainer = new YarnProgram();

					using (var memoryStream = new MemoryStream())
					using (var outputStream = new Google.Protobuf.CodedOutputStream(memoryStream)) {

						// Serialize the compiled program to memory
						compiledProgram.WriteTo(outputStream);
						outputStream.Flush();

						byte[] compiledBytes = memoryStream.ToArray();

						programContainer.compiledProgram = compiledBytes;

						// var outPath = Path.ChangeExtension(ctx.assetPath, ".yarnc");
						// File.WriteAllBytes(outPath, compiledBytes);
					}

					if (stringTable.Count > 0) {
						Debug.LogWarning("Currently not handling string table at runtime");
					}
					Debug.Log(programContainer.GetProgram().CalculateSize());

					int currentSceneIndex = SceneManager.GetActiveScene().buildIndex;
					Settings.onFinish = () => {
						Settings.selectedYarn = null;
						SceneManager.LoadScene(currentSceneIndex);
					};

					Settings.selectedYarn = programContainer;
					SceneManager.LoadScene(testSceneIndex);

				}
				catch (ParseException e) {
					Debug.LogError(e.Message);
					return;
				}

			}
		}

	}
}
