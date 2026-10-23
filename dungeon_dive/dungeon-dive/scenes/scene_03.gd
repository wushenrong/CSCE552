extends CanvasLayer


@export var board: Node2D


func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	show()


func _on_rules_button_pressed() -> void:
	SceneManager.show_rules()


func _on_settings_button_pressed() -> void:
	SceneManager.show_settings()


func _on_save_button_pressed() -> void:
	board.save_game()
	SceneManager.goto_scene("res://scenes/scene_01.tscn")


func _on_back_button_pressed() -> void:
	hide()
	get_tree().paused = false
