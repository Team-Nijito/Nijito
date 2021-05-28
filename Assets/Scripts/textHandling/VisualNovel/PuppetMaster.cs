using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Assertions;

namespace Dialogue.VN
{

	/// <summary>
	/// This is in charge of creating and supplying puppets for the command system.
	/// Though puppets are fairly self-sufficient, they are not able to create themselves.
	///
	/// This looks for puppets in the Resources/Puppets folder.
	/// </summary>
	public class PuppetMaster : MonoBehaviour
	{
		public const string PuppetPrefabPath = "Puppets";

		//public GameObject puppetPrefab;
		[SerializeField] private GameObject puppetPrefab;
		[SerializeField] private StagePoint puppetSpawnPoint;
		[SerializeField] private SlideRenderer puppetRenderer;
		[SerializeField] private bool deleteChildrenOnStart = true;

		//private GameObject[] puppetPrefabs;
		private Dictionary<string, Puppet> activePuppets;

		private void Awake()
		{
			activePuppets = new Dictionary<string, Puppet>();

            Assert.IsNotNull(
                puppetPrefab.GetComponent<Puppet>(),
                "Puppet prefab (" + puppetPrefab.name + ") must have the Dialogue.VN.Puppet component attached to it!"
            );

			Assert.IsNotNull(puppetRenderer);

			/*
			puppetPrefabs = Resources.LoadAll<GameObject>(PuppetPrefabPath);
            foreach (GameObject prefab in puppetPrefabs) {
				Assert.IsNotNull(
					prefab.GetComponent<Puppet>(),
					"Puppet prefab (" + prefab.name + ") must have the Dialogue.VN.Puppet component attached to it!"
				);
			}
			*/
		}

		private void Start() {
			if(deleteChildrenOnStart) {
				foreach(Transform child in transform) {
					Destroy(child.gameObject);
				}
			}
		}

		/// <summary>
		/// Gets the puppet which matches the given name.
		/// 
		/// If the puppet does not exist, it will be created using whatever preset seems to
		/// best match based on the name. If it can't figure out which puppet to use,
		/// it will create a generic one. This generic puppet will still behave correctly,
		/// but it will not look correct. When generic puppet is used,
		/// a warning is printed in the debug console.
		/// </summary>
		/// <param name="characterName">Name of the character we are making a puppit for. This is case insensitive.</param>
		/// <returns>The puppet, whether newly created or previously existing.</returns>
		public Puppet GetPuppet(string characterName)
		{
			Puppet result;
			if(!activePuppets.TryGetValue(characterName, out result))
			{
				result = MakePuppet(characterName);
				activePuppets.Add(characterName, result);
			}

			return result;
		}

		private Puppet MakePuppet(string characterName)
		{
			/*
			GameObject prefab = puppetPrefabs.FirstOrDefault(
				p => characterName.Equals(p.name, System.StringComparison.OrdinalIgnoreCase)
			);
			if(prefab == null) {
				Debug.LogWarning("Could not find character: " + characterName);
				prefab = puppetPrefab;
            }
			*/

			GameObject newPuppetObj = Instantiate( puppetPrefab, transform );
			newPuppetObj.name = characterName;

			Puppet newPuppet = newPuppetObj.GetComponent<Puppet>();
			newPuppet.RendererHandle = puppetRenderer.NewTexture(characterName, (int)newPuppet.RendererWidth, (int)newPuppet.RendererHeight);
			newPuppet.Warp(puppetSpawnPoint);

			return newPuppet;
		}

	}
}
