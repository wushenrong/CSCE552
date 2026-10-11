extends Node2D


var screen_size
var current_dragged_card


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_dragged_card:
		var mouse_position = get_global_mouse_position()
		current_dragged_card.position = Vector2(clamp(mouse_position.x, 0, screen_size.x), clamp(mouse_position.y, 0, screen_size.y))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()

			if card:
				current_dragged_card = card
		else:
			current_dragged_card = null

func raycast_check_for_card():
	# Taken from Godot documentation
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()

	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1

	var result = space_state.intersect_point(parameters)

	if result:
		return result[0].collider.get_parent()

	return null
