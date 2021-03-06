﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

namespace Dialogue.VN {
	/// <summary>
	/// Provides various functions which make it easier to handle the arguments for commands.
	/// </summary>
	public static class CommandProcessing {

		/// <summary>
		/// Attempts to fetch a string value from the array of arguments.
		/// This value can be enclosed in double quotes.
		/// </summary>
		/// 
		/// <param name="args">Array of arguments passed into function.</param>
		/// <param name="i">
		/// Index into argument array. May be out of bounds.
		/// If a valid string is found, this gets incremented based on number of args consumed.
		/// </param>
		///
		/// <returns>
		/// The string without double quotes. 
		/// If no string is found, null is returned instead.
		/// </returns>
		public static string ReadStringArgument(string[] args, ref int i) {
			string result = null;

			if(i < args.Length) {
				result = args[i];
				i++;

				if(result.StartsWith("\"")) {
					while(i < args.Length && !result.EndsWith("\"")) {
						result += " " + args[i];
						i++;
					}

					Assert.IsTrue(result.EndsWith("\""));
					result = result.Substring(1, result.Length - 2);
					Debug.Log(result);
				}
			}

			return result;
		}

		/// <summary>
		/// Attempts to fetch a speed value from the array of arguments.
		/// This consumes 'quickly', 'slowly', and 'now'.
		/// </summary>
		/// 
		/// <param name="args">Array of arguments passed into function.</param>
		/// <param name="i">
		/// Index into argument array. May be out of bounds.
		/// If a valid speed is found, this gets incremented.
		/// </param>
		/// <param name="result">
		/// Speed which was found from the given argument.
		/// This does not change if the argument is not a valid speed.
		/// </param>
		///
		/// <returns>True if a valid speed argument was found.</returns>
		public static bool ReadSpeedArgument(string[] args, ref int i, ref Speed result) {
			bool success = false;

			if (i < args.Length) {
				switch (args[i].ToLower()) {
					case "quickly":
						result = Speed.Quick;
						success = true;
						break;
					case "slowly":
						result = Speed.Slow;
						success = true;
						break;
					case "now":
						result = Speed.Now;
						success = true;
						break;
					default:
						success = false;
						break;
				}

				if (success) {
					i++; // consume the arg
				}
			}

			return success;
		}

		/// <summary>
		/// Attempts to fetch a wait value from the array of arguments.
		/// This consumes 'wait' and 'and wait'.
		/// </summary>
		/// 
		/// <param name="args">Array of arguments passed into function.</param>
		/// <param name="i">
		/// Index into argument array. May be out of bounds.
		/// If a valid argument is found, this gets incremented.
		/// </param>
		/// <param name="result">
		/// Wait value which was found from the given argument.
		/// This does not change if the argument is not valid.
		/// </param>
		///
		/// <returns>True if valid arguments were found.</returns>
		public static bool ReadWaitArgument(string[] args, ref int i, ref bool result) {
			bool success = false;

			if(i < args.Length) {
				switch(args[i].ToLower()) {
					case "and":
						++i;
						success = ReadWaitArgument(args, ref i, ref result);
						break;
					case "wait":
						++i;
						result = true;
						success = true;
						break;
				}
			}

			return success;
		}

	}
}
