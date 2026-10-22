extends CanvasLayer


func _on_wave_failed(wave: int, owned_rewards: Array) -> void:
	var reward_names = owned_rewards.map(func(reward): return reward["name"])

	%DefeatLabel.text = "You have been defeated on Wave %d" % wave
	%HighestWaveLabel.text = "Highest Wave Achieved: %d" % PlayerSettings.highest_wave
	%RewardsLabel.text = "Rewards: " + (", ".join(PackedStringArray(reward_names)) if reward_names else "None")
	get_tree().paused = true
	show()


func _on_main_menu_button_pressed() -> void:
	SceneManager.goto_scene("res://scenes/scene_01.tscn")
