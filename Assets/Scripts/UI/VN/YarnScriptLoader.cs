using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Yarn.Unity;

public class YarnScriptLoader : MonoBehaviour
{
    public YarnProgram script;
    public DialogueRunner runner;

    void Start()
    {
        runner.Add(script);
        //runner.StartDialogue(script.GetProgram().Name);
        runner.StartDialogue();
    }

}
