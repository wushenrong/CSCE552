extends CanvasLayer


func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	show()


func _on_settings_button_pressed() -> void:
	SceneManager.show_settings()


func _on_load_save_button_pressed() -> void:
	SaveManager.load_game()


func _on_save_button_pressed() -> void:
	SaveManager.save_game()

	get_tree().paused = false

	SceneManager.change_scene("res://scenes/scene_01.tscn")


func _on_back_button_pressed() -> void:
	get_tree().paused = false
	hide()
