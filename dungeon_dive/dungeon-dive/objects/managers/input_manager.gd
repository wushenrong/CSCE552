extends Node2D


signal left_mouse_button_clicked
signal left_mouse_button_released


const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 4


@export var card_manager: Node2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			left_mouse_button_clicked.emit()
			raycast_at_cursor()
		else:
			left_mouse_button_released.emit()


func raycast_at_cursor():
	# Taken from Godot documentation
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()

	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true

	var result = space_state.intersect_point(parameters)

	if result:
		var collider = ManagerUtilities.get_highest_z_index_collider(result)
		var result_collision_mask = collider.collision_mask

		match result_collision_mask:
			COLLISION_MASK_CARD:
				var card_found = collider.get_parent()

				if card_found:
					card_manager.start_drag(card_found)
			COLLISION_MASK_DECK:
				card_manager.new_card()
			_:
				pass
