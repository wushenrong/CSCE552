extends Node2D


const CARD_PLACED_SFX = preload("res://assets/sound_effects/card_placed_down_fx.wav")
const CARD_DRAWN_SFX = preload("res://assets/sound_effects/card_draw_from_deck_fx.wav")


const COLLISION_MASK_CARD = 1
const COLLISION_MASK_TILE = 2


var screen_size: Vector2
var card_being_dragged: Node2D = null
var is_hovered_on_card := false

var board_cards := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board_cards.resize(25)
	board_cards.fill(null)
	screen_size = get_viewport_rect().size
	$"../InputManager".left_mouse_button_released.connect(on_left_click_released.bind())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_position = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_position.x, 0, screen_size.x), clamp(mouse_position.y, 0, screen_size.y))


func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)
	card.stop_idle_hover()
	play_card_sfx(CARD_DRAWN_SFX)


func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)

	var card_slot_found = raycast_check_for_tile()

	if card_slot_found and not card_slot_found.is_card_in_slot:
		place_card(card_being_dragged, card_slot_found)

		var total = $"../ScoreManager".score_board(board_cards)

		if not board_cards.has(null):
			$"../WaveManager".end_wave(total)
	else:
		$"../HandSlot".hold_card(card_being_dragged)

	card_being_dragged = null

	play_card_sfx(CARD_PLACED_SFX)


# Locks the card onto the tile, it can no longer be dragged
func place_card(card, tile):
	card.position = tile.position
	card.get_node("Area2D/CollisionShape2D").disabled = true
	# Same as an unhovered card in highlight_card, so it draws above the tile
	card.z_index = 1
	tile.is_card_in_slot = true

	var tile_index = int(tile.name.trim_prefix("Tile"))
	card.tile_index = tile_index
	board_cards[tile_index] = card


func clear_board():
	for card in board_cards:
		if card:
			card.queue_free()

	board_cards.fill(null)
	is_hovered_on_card = false

	get_tree().call_group("tiles", "reset_tile")


func connect_card_signals(card):
	card.hover_on.connect(on_hover_on_card.bind())
	card.hover_off.connect(on_hover_off_card.bind())


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


func play_card_sfx(stream: AudioStream):
	$CardSFX.stream = stream
	$CardSFX.play()

	await $CardSFX.finished


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


func get_save_data() -> Dictionary:
	# Drawn cards that were not placed yet are still waiting in the HandSlot
	var hand_cards = get_tree().get_nodes_in_group("cards").filter(func(card): return card.tile_index == -1)

	return {
		"board_cards": board_cards.map(func(card): return card.get_card_data() if card else null),
		"hand_cards": hand_cards.map(func(card): return card.get_card_data()),
	}


func load_save_data(data: Dictionary) -> void:
	# board_cards is in tile order, null for an empty tile
	for tile_index in data["board_cards"].size():
		var card_data = data["board_cards"][tile_index]

		if card_data:
			place_card($"../Deck".spawn_card(card_data), get_node("../Tile%d" % tile_index))

	for card_data in data["hand_cards"]:
		$"../HandSlot".hold_card($"../Deck".spawn_card(card_data))
