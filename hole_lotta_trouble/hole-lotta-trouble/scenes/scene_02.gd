extends CanvasLayer


func _on_back_button_pressed() -> void:
	SettingsManager.save_settings()
	get_tree().root.remove_child(self)
