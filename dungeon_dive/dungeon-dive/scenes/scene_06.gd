extends CanvasLayer


@export var board: Node2D


func _ready() -> void:
	if board:
		board.on_wave_failed = on_wave_failed


func on_wave_failed(wave: int, owned_rewards: Array) -> void:
	var reward_names = owned_rewards.map(func(reward): return reward["name"])

	%DefeatLabel.text = "You have been defeated on Wave %d" % wave
	%HighestWaveLabel.text = "Highest Wave Achieved: %d" % PlayerSettings.highest_wave
	%RewardsLabel.text = "Rewards: " + (", ".join(PackedStringArray(reward_names)) if reward_names else "None")
	get_tree().paused = true
	show()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	SceneManager.goto_scene("res://scenes/scene_01.tscn")
