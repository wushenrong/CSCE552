extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/ContinueButton.disabled = not SaveManager.has_save_file()


func _on_new_game_button_pressed() -> void:
	SaveManager.delete_save()
	SceneManager.change_scene("res://scenes/scene_03.tscn")


func _on_continue_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/scene_03.tscn")


func _on_settings_button_pressed() -> void:
	SceneManager.show_settings()


func _on_quit_game_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
