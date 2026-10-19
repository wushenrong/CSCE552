extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	show()


func _on_settings_button_pressed() -> void:
	SceneManager.show_settings()


func _on_save_button_pressed() -> void:
	# TODO: Perform saving game process here
	SceneManager.goto_scene("res://scenes/scene_01.tscn")


func _on_back_button_pressed() -> void:
	hide()
	get_tree().paused = false
