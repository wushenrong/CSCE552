extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ContinueButton.visible = SaveManager.has_save()


# The Board loads the saved run by itself when it finds one
func _on_continue_button_pressed() -> void:
	SceneManager.goto_scene("res://scenes/scene_04.tscn")


func _on_start_button_pressed() -> void:
	# A new run replaces the saved one
	SaveManager.delete_save()
	SceneManager.goto_scene("res://scenes/scene_04.tscn")


func _on_settings_button_pressed() -> void:
	SceneManager.show_settings()


func _on_exit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
