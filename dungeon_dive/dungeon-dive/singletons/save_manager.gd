extends Node

# Kept apart from PlayerSettings' settings.cfg so a run can be deleted on its own
const SAVE_FILE = "user://save.cfg"
const RUN_KEY = "run"

var config := ConfigFile.new()


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_FILE)


# run: one Dictionary per Board node, see Board.save_game
func save_run(run: Dictionary):
	config.clear()

	for key in run:
		config.set_value(RUN_KEY, key, run[key])

	config.save(SAVE_FILE)


# Returns an empty Dictionary when there is no run to continue
func load_run() -> Dictionary:
	var run = {}

	config.clear()
	var error = config.load(SAVE_FILE)

	if error != OK or not config.has_section(RUN_KEY):
		return run

	for key in config.get_section_keys(RUN_KEY):
		run[key] = config.get_value(RUN_KEY, key)

	return run


# Called when a run ends or a new one starts, Continue is hidden on the main menu after this
func delete_save():
	if has_save():
		DirAccess.remove_absolute(SAVE_FILE)
