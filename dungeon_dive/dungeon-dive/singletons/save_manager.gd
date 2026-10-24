extends Node

# Kept apart from PlayerSettings' settings.cfg so a run can be deleted on its own
const SAVE_FILE = "user://savegame.save"


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_FILE)


# run: one Dictionary per Board node, see Board.save_game
func save_run(run: Dictionary):
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	var json_string = JSON.stringify(run)
	save_file.store_line(json_string)


# Returns an empty Dictionary when there is no run to continue
func load_run() -> Dictionary:
	if not has_save():
		return {}

	var save_file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)

	if parse_result != OK:
		return {}

	return json.data


# Called when a run ends or a new one starts, Continue is hidden on the main menu after this
func delete_save():
	if has_save():
		DirAccess.remove_absolute(SAVE_FILE)
