extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		_unpause_game()


func pause_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	get_tree().paused = true
	show()


func _unpause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	hide()


func _on_settings_button_pressed() -> void:
	SceneManager.show_settings()


func _on_load_save_button_pressed() -> void:
	SaveManager.load_game()


func _on_save_button_pressed() -> void:
	SaveManager.save_game()

	get_tree().paused = false

	SceneManager.change_scene("res://scenes/scene_01.tscn")


func _on_back_button_pressed() -> void:
	_unpause_game()
