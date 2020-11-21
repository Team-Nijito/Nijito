using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Assertions;

namespace Dialogue.VN
{
	public class PuppetMaster : MonoBehaviour
	{
		//public GameObject puppetPrefab;
		public GameObject defaultPuppetPrefab;
		public GameObject[] puppetPrefabs;
		public RectTransform puppetSpawnPoint;

		Dictionary<string, Puppet> activePuppets;

		private void Awake()
		{
			activePuppets = new Dictionary<string, Puppet>();

            Assert.IsNotNull(
                defaultPuppetPrefab.GetComponent<Puppet>(),
                "Puppet prefab (" + defaultPuppetPrefab.name + ") must have the Dialogue.VN.Puppet component attached to it!"
            );
            foreach (GameObject prefab in puppetPrefabs) {
				Assert.IsNotNull(
					prefab.GetComponent<Puppet>(),
					"Puppet prefab (" + prefab.name + ") must have the Dialogue.VN.Puppet component attached to it!"
				);
			}
		}

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
			GameObject prefab = puppetPrefabs.FirstOrDefault(
				p => characterName.Equals(p.name, System.StringComparison.OrdinalIgnoreCase)
			);
			if(prefab == null) {
				Debug.LogWarning("Could not find character: " + characterName);
				prefab = defaultPuppetPrefab;
            }

			GameObject newPuppetObj = Instantiate( prefab, transform );

			Puppet newPuppet = newPuppetObj.GetComponent<Puppet>();
			newPuppet.Warp(puppetSpawnPoint);

			return newPuppet;
		}

	}
}
