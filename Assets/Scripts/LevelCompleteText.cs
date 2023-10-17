using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LevelCompleteText : MonoBehaviour
{
    public static bool showText;
    public Text levelCompleteText;
    
    // Start is called before the first frame update
    void Start()
    {
        showText = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (showText) {
            levelCompleteText.text = "LEVEL COMPLETE";
        } else {
            levelCompleteText.text = "";
        }
    }
}
