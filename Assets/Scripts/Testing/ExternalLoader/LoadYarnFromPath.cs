using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Assertions;
using Yarn.Compiler;
using UnityEngine.SceneManagement;
using System.IO;
using System.Globalization;

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
				// TODO Shove this into the Settings class or something...
				//      This is way too much (highly valuable code) to leave in this component.
				//
				// Oh on that note, this code came out of Yarn's private scripts. For some reason,
				// they make the Compiler publicly accessable and then don't give you any way to
				// convert compiled programs into YarnPrograms, which the runner clearly needs to
				// function. I'm should make an issue on the Yarn Spinner repo about this...

				Yarn.Program compiledProgram;

				IDictionary<string, Yarn.Compiler.StringInfo> stringTable;
				string fileName = Path.GetFileNameWithoutExtension(pathSrc.text);
				YarnTranslation[] localizations = new YarnTranslation[0];
				Status compilationStatus;
				string baseLanguageID = CultureInfo.CurrentCulture.Name;

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
						using (var memoryStream = new MemoryStream())
						using (var textWriter = new StreamWriter(memoryStream)) {
							// Generate the localised .csv file

							// Use the invariant culture when writing the CSV
							var configuration = new CsvHelper.Configuration.Configuration(
								System.Globalization.CultureInfo.InvariantCulture
							);

							var csv = new CsvHelper.CsvWriter(
								textWriter, // write into this stream
								configuration // use this configuration
								);

							var lines = stringTable.Select(x => new {
								id = x.Key,
								text = x.Value.text,
								file = x.Value.fileName,
								node = x.Value.nodeName,
								lineNumber = x.Value.lineNumber
							});

							csv.WriteRecords(lines);

							textWriter.Flush();

							memoryStream.Position = 0;

							using (var reader = new StreamReader(memoryStream)) {
								var textAsset = new TextAsset(reader.ReadToEnd());
								textAsset.name = $"{fileName} ({baseLanguageID})";

								programContainer.baseLocalisationStringTable = textAsset;
								programContainer.localizations = localizations;
							}

							//stringIDs = lines.Select(l => l.id).ToArray();

						}
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
