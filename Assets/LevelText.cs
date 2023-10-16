using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class LevelText : MonoBehaviour
{
    public Text levelText;
    
    public static int level = 1;
    
    // Start is called before the first frame update
    void Start()
    {
        SceneManager.activeSceneChanged += ChangedActiveScene;
    }

    // Update is called once per frame
    void Update()
    {
        levelText.text = "Level: " + level;    
    }

    private void ChangedActiveScene(Scene current, Scene next) {
		if (next.name != "Play") {
            LevelText.level = 1;
		}
	}
}
