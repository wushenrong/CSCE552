extends Node2D


const CardPlacedSFX = preload("res://assets/sound_effects/card_placed_down_fx.wav")
const CardDrawnSFX = preload("res://assets/sound_effects/card_draw_from_deck_fx.wav")


const COLLISION_MASK_CARD = 1
const COLLISION_MASK_TILE = 2


@export var input_manager: Node2D
@export var deck: Node2D
@export var card_sfx: AudioStreamPlayer2D


var screen_size: Vector2
var card_being_dragged: Node2D = null
var is_hovered_on_card := false

var board_cards := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_cards.resize(25)
	board_cards.fill(null)
	screen_size = get_viewport_rect().size
	input_manager.left_mouse_button_released.connect(on_left_click_released)
	deck.add_card = add_card


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_position = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_position.x, 0, screen_size.x), clamp(mouse_position.y, 0, screen_size.y))


func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)
	play_card_sfx(CardDrawnSFX)


func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)

	var card_slot_found = raycast_check_for_tile()

	if card_slot_found and not card_slot_found.is_card_in_slot:
		card_being_dragged.position = card_slot_found.position
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.is_card_in_slot = true
		var tile_index = int(card_slot_found.name.trim_prefix("Tile"))
		board_cards[tile_index] = card_being_dragged
	else:
		card_being_dragged.position = deck.position

	card_being_dragged = null

	play_card_sfx(CardPlacedSFX)

	#get_tree().call_group("tiles", "reset_tile")


func add_card(card):
	add_child(card)

	if not card.hovered_over.is_connected(on_hovered_over_card):
		card.hovered_over.connect(on_hovered_over_card)

	if not card.hovered_off.is_connected(on_hovered_off_card):
		card.hovered_off.connect(on_hovered_off_card)


func on_left_click_released():
	if card_being_dragged:
		finish_drag()


func on_hovered_over_card(card):
	if not is_hovered_on_card:
		is_hovered_on_card = true
		highlight_card(card, true)


func on_hovered_off_card(card):
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


func new_card():
	deck.draw_card()


func play_card_sfx(stream: AudioStream):
	card_sfx.stream = stream
	card_sfx.play()


func masked_raycast(collision_mask: int):
	# Taken from Godot documentation
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()

	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = collision_mask

	return space_state.intersect_point(parameters)


func raycast_check_for_card():
	var result = masked_raycast(COLLISION_MASK_CARD)

	if result:
		return ManagerUtilities.get_highest_z_index_collider(result).get_parent()

	return null


func raycast_check_for_tile():
	var result = masked_raycast(COLLISION_MASK_TILE)

	if result:
		return result[0].collider.get_parent()

	return null
