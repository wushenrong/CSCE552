extends Node3D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		$PauseMenu.pause_game()
