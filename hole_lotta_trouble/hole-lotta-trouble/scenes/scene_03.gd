extends Node3D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		$PauseMenu.pause_game()


func _on_player_died() -> void:
	$DiedMessage.show_died_message()


func _on_died_message_respawn():
	# TODO: Set repsawn location
	$Player.respawn()
