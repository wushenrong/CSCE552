extends CanvasLayer


signal respawn


func show_died_message():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()


func hide_died_message():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	respawn.emit()
	hide()
