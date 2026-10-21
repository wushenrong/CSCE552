extends Node


var settings_scene: Node
var current_scene: Node = null


func _ready():
	var root = get_tree().root
	current_scene = root.get_child(-1)

	settings_scene = preload("res://scenes/scene_02.tscn").instantiate()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		settings_scene.queue_free()
		get_tree().quit()


func goto_scene(path: String):
	_deferred_goto_scene.call_deferred(path)


func _deferred_goto_scene(path: String):
	current_scene.free()

	var s = ResourceLoader.load(path)

	current_scene = s.instantiate()

	get_tree().root.add_child(current_scene)

	get_tree().current_scene = current_scene


func show_settings():
	if not settings_scene.is_inside_tree():
		get_tree().root.add_child(settings_scene)
