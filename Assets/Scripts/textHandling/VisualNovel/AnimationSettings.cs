using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Dialogue.VN {

	/// <summary>
	/// Handles playing animations from the VN system.
	/// 
	/// This object is meant to contain editor-time settings, and does not
	/// change while the game runs.
	/// </summary>
	[CreateAssetMenu(menuName = "Nijito/VN/Animation Settings", fileName = "NewAnimationSettings")]
	public class AnimationSettings : ScriptableObject {

		[SerializeField] private string speedControl = "speed";
		[SerializeField] private float normalAnimationSpeed = 1f;
		[SerializeField] private float quickAnimationSpeed = 2f;
		[SerializeField] private float slowAnimationSpeed = 0.5f;
		[SerializeField] private float nowAnimationSpeed = 1000f;

		/// <summary>
		/// Attempts to play an animation. There is very little checking in place,
		/// so a bad animation name could yield garbage.
		/// </summary>
		/// <param name="animator"></param>
		/// <param name="name"></param>
		/// <param name="speed"></param>
		/// <param name="wait"></param>
		/// <param name="onComplete"></param>
		/// <returns></returns>
		public IEnumerator PlayAnim(Animator animator, string name, Speed speed, bool wait = false, Action onComplete = null) {

			animator.SetFloat(speedControl, SpeedToScale(speed));
			animator.Play(name);

			if (onComplete != null && wait) {
				yield return WaitForAnim(animator, onComplete);
			}
			else {
				onComplete();
				yield return null;
			}

		}

		private IEnumerator WaitForAnim(Animator animator, Action onComplete) {
			// This works even for loops; the time counts on from 1 even after first loop

			yield return new WaitForEndOfFrame(); // Wait for the animation to start playing
			yield return new WaitUntil(() =>
				animator.GetCurrentAnimatorStateInfo(0).normalizedTime >= 1
			);
			onComplete();
		}

		public float SpeedToScale(Speed speed) {
			switch (speed) {
				default:           goto case Speed.Normal;
				case Speed.Normal: return normalAnimationSpeed;
				case Speed.Quick:  return quickAnimationSpeed;
				case Speed.Slow:   return slowAnimationSpeed;
				case Speed.Now:    return nowAnimationSpeed;
			}
		}
	}
}
