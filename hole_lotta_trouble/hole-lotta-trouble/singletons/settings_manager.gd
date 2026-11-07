extends Node


@export_range(0.0, 0.1, 0.01) var master_volume: float = 1.0
@export_range(0.0, 0.1, 0.01) var music_volume: float = 1.0
@export_range(0.0, 0.1, 0.01) var sfx_volume: float = 1.0


const SETTINGS_FILE = "user://settings.cfg"
const VOLUME_KEY = "volume"


@export var master_volume_bus_name := "Master"
@export var music_volume_bus_name := "Music"
@export var sfx_volume_bus_name := "SFX"


var config := ConfigFile.new()


@onready var _master_volume_bus := AudioServer.get_bus_index(master_volume_bus_name)
@onready var _music_volume_bus := AudioServer.get_bus_index(music_volume_bus_name)
@onready var _sfx_volume_bus := AudioServer.get_bus_index(sfx_volume_bus_name)


func _ready() -> void:
	var error = config.load(SETTINGS_FILE)

	if error != OK:
		return

	master_volume = config.get_value(VOLUME_KEY, "master", master_volume)
	music_volume = config.get_value(VOLUME_KEY, "music", music_volume)
	sfx_volume = config.get_value(VOLUME_KEY, "sfx", sfx_volume)

	AudioServer.set_bus_volume_db(_master_volume_bus, linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(_music_volume_bus, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(_sfx_volume_bus, linear_to_db(sfx_volume))


func save_settings():
	config.set_value(VOLUME_KEY, "master", master_volume)
	config.set_value(VOLUME_KEY, "music", music_volume)
	config.set_value(VOLUME_KEY, "sfx", sfx_volume)
	config.save(SETTINGS_FILE)
