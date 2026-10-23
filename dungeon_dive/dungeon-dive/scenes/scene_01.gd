extends CanvasLayer


func _on_start_button_pressed() -> void:
	SceneManager.goto_scene("res://scenes/scene_04.tscn")


func _on_settings_button_pressed() -> void:
	SceneManager.show_settings()


func _on_exit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
