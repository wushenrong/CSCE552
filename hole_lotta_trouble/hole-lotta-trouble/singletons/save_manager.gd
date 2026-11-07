extends Node


const SAVE_FILE = "user://savegame.save"


func save_game():
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)

	# TODO: Save Nodes
	pass


func load_game():
	if not has_save_file():
		return

	# TODO: Load Nodes
	pass


func has_save_file():
	return FileAccess.file_exists(SAVE_FILE)


func delete_save():
	if has_save_file():
		DirAccess.remove_absolute(SAVE_FILE)
