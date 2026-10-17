extends Node2D


const COLLISION_MASK_CARD = 1
const COLLISION_MASK_TILE = 2


var screen_size
var card_being_dragged = null
var is_hovered_on_card = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_position = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_position.x, 0, screen_size.x), clamp(mouse_position.y, 0, screen_size.y))


func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)


func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)

	var card_slot_found = raycast_check_for_tile()

	if card_slot_found and not card_slot_found.is_card_in_slot:
		card_being_dragged.position = card_slot_found.position
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.is_card_in_slot = true
	else:
		card_being_dragged.position = $"../Deck".position

	card_being_dragged = null


func connect_card_signals(card):
	card.connect("hover_on", on_hover_on_card)
	card.connect("hover_off", on_hover_off_card)


func on_left_click_released():
	if card_being_dragged:
		finish_drag()


func on_hover_on_card(card):
	if not is_hovered_on_card:
		is_hovered_on_card = true
		highlight_card(card, true)


func on_hover_off_card(card):
	if not card_being_dragged:
		highlight_card(card, false)

		var new_card_hovered = raycast_check_for_card()

		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovered_on_card = false


func highlight_card(card, is_being_hovered_over):
		if is_being_hovered_over:
			card.scale = Vector2(1.05, 1.05)
			card.z_index = 2
		else:
			card.scale = Vector2(1, 1)
			card.z_index = 1


func raycast_check_for_card():
	# Taken from Godot documentation
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()

	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD

	var result = space_state.intersect_point(parameters)

	if result:
		return get_card_with_highest_z_index(result)

	return null


func raycast_check_for_tile():
	# Taken from Godot documentation
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()

	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_TILE

	var result = space_state.intersect_point(parameters)

	if result:
		return result[0].collider.get_parent()

	return null


func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()

	for card in cards:
		var current_card = card.collider.get_parent()

		if current_card.z_index > highest_z_card.z_index:
			highest_z_card = current_card

	return highest_z_card
