extends Node


const SAVE_FILE = "user://savegame.save"


func save_game():
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)

	# TODO: Save Nodes
	pass


func load_game():
	if not FileAccess.file_exists(SAVE_FILE):
		return

	# TODO: Load Nodes
	pass
