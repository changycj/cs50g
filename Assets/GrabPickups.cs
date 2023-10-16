using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GrabPickups : MonoBehaviour {

	private AudioSource pickupSoundSource;

	private bool alreadyHit = false;

	void Awake() {
		pickupSoundSource = DontDestroy.instance.GetComponents<AudioSource>()[1];
	}

	void OnControllerColliderHit(ControllerColliderHit hit) {
		if (hit.gameObject.tag == "Pickup" && !alreadyHit) {
			pickupSoundSource.Play();
			LevelText.level += 1;
			SceneManager.LoadScene("Play");
			alreadyHit = true;
		}
	}

}
