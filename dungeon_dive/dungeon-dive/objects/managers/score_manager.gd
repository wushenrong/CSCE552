class_name ScoreManager
extends Node2D
## Scores the 5x5 board: 5 rows + 5 columns, each scored as a poker hand.
## line score = points (American Poker Squares) x mult


const SINGLE_COIN_FX = preload("res://assets/sound_effects/single_coin_falling_fx.wav")
const DOUBLE_COIN_FX = preload("res://assets/sound_effects/double_coins_falling_fx.wav")
const COINS_FALLING_FX = preload("res://assets/sound_effects/coins_falling_fx.wav")


const BOARD_SIZE = 5
const CARD_SIZE = Vector2(96, 128)
const HIGHLIGHT_PADDING = 8

# Reward modifier values, see RewardData descriptions
const RANK_BONUS_POINTS = 5
const RANK_MULTIPLIER = 1.1

# Boss debuff values, see BossData descriptions
const TILE_PENALTY_POINTS = 3
const SUIT_DEBUFF_MULTIPLIER = 0.5

enum Hand {
	NONE,
	HIGH_CARD,
	PAIR,
	TWO_PAIR,
	THREE_OF_A_KIND,
	STRAIGHT,
	FLUSH,
	FULL_HOUSE,
	FOUR_OF_A_KIND,
	STRAIGHT_FLUSH,
	ROYAL_FLUSH
}

const HAND_POINTS = {
	Hand.NONE: 0,
	Hand.HIGH_CARD: 0,
	Hand.PAIR: 2,
	Hand.TWO_PAIR: 5,
	Hand.THREE_OF_A_KIND: 10,
	Hand.STRAIGHT: 15,
	Hand.FLUSH: 20,
	Hand.FULL_HOUSE: 25,
	Hand.FOUR_OF_A_KIND: 50,
	Hand.STRAIGHT_FLUSH: 75,
	Hand.ROYAL_FLUSH: 100,
}

const HAND_NAMES = {
	Hand.NONE: "No Cards",
	Hand.HIGH_CARD: "High Card",
	Hand.PAIR: "Pair",
	Hand.TWO_PAIR: "Two Pair",
	Hand.THREE_OF_A_KIND: "Three of a Kind",
	Hand.STRAIGHT: "Straight",
	Hand.FLUSH: "Flush",
	Hand.FULL_HOUSE: "Full House",
	Hand.FOUR_OF_A_KIND: "Four of a Kind",
	Hand.STRAIGHT_FLUSH: "Straight Flush",
	Hand.ROYAL_FLUSH: "Royal Flush",
}


var row_labels := []
var column_labels := []
var line_breakdown := []
var last_line := {}
# One entry per line, rows 1-5 then columns 1-5, read by the HandPanel
var line_results := []
var highlighted_index := -1
var highlight_color: Color


func _ready() -> void:
	# Gold comes from %LineHighlight's border colour in board.tscn
	highlight_color = %LineHighlight.get_theme_stylebox("panel").border_color

	for i in BOARD_SIZE:
		row_labels.append(get_node("RowScore%d" % i))
		column_labels.append(get_node("ColumnScore%d" % i))


## board: 25 cards in row order (index = row * 5 + col), null for an empty tile.

## board: 25 cards in row order (index = row * 5 + col), null for an empty tile.
func score_board(board: Array) -> int:
	var total = 0
	var pitch = 1.0
	line_results.clear()

	for i in BOARD_SIZE:
		total += score_line(get_row(board, i))
		record_line("Row %d" % (i + 1), row_labels[i])
		play_scoring_sfx(total, pitch)
		pitch += 0.2

	for i in BOARD_SIZE:
		total += score_line(get_column(board, i))
		record_line("Column %d" % (i + 1), column_labels[i])
		play_scoring_sfx(total, pitch)
		pitch += 0.2

	if total > 0:
		play_score_sfx(COINS_FALLING_FX, 1.0)

	%ScoreLabel.text = "Score: %d" % total
	$"../HandPanel".update_board(line_results)

	return total


func score_line(cards: Array) -> int:
	var hand = evaluate_hand(cards)
	var points = HAND_POINTS[hand]
	var mult = 1.0
	var placed_cards = cards.filter(func(card): return card != null)

	line_breakdown = ["%s: %d points" % [HAND_NAMES[hand], points]]

	points = apply_debuffs_to_points(placed_cards, hand, points)
	mult = apply_debuffs_to_mult(placed_cards, hand, mult)
	points = apply_modifiers_to_points(placed_cards, hand, points)
	mult = apply_modifiers_to_mult(placed_cards, hand, mult)

	var line_score = max(int(points * mult), 0)

	if hand == Hand.HIGH_CARD:
		line_breakdown.append("Rewards need a Pair or better")

	last_line = {
		"hand": hand,
		"points": int(points),
		"mult": mult,
		"score": line_score,
		"breakdown": line_breakdown,
	}
	return line_score


func get_row(board: Array, row: int) -> Array:
	# Each row is 150px apart from center of card/tile
	var cards = []
	for col in BOARD_SIZE:
		cards.append(board[row * BOARD_SIZE + col])
	return cards


func get_column(board: Array, col: int) -> Array:
	# Each column is 120px apart from center of card/tile
	var cards = []
	for row in BOARD_SIZE:
		cards.append(board[row * BOARD_SIZE + col])
	return cards


## Connected to each RowScore/ColumnScore label in board.tscn, line_index is bound there.
func _on_line_label_gui_input(event: InputEvent, line_index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		$"../HandPanel".open_line(line_index)


## line_index: rows 0-4 then columns 5-9, -1 to clear. Outlines the line's tiles and its score.
func highlight_line(line_index: int) -> void:
	if highlighted_index != -1:
		get_line_label(highlighted_index).remove_theme_color_override("font_color")

	highlighted_index = line_index

	if line_index == -1:
		%LineHighlight.hide()
		return

	var first_tile = line_index * BOARD_SIZE
	var last_tile = first_tile + BOARD_SIZE - 1

	if line_index >= BOARD_SIZE:
		first_tile = line_index - BOARD_SIZE
		last_tile = first_tile + (BOARD_SIZE - 1) * BOARD_SIZE

	var label = get_line_label(line_index)
	var line_rect = Rect2(label.position, label.size)
	line_rect = line_rect.merge(Rect2(get_node("../Tile%d" % first_tile).position - CARD_SIZE / 2, CARD_SIZE))
	line_rect = line_rect.merge(Rect2(get_node("../Tile%d" % last_tile).position - CARD_SIZE / 2, CARD_SIZE))

	var padding = Vector2(HIGHLIGHT_PADDING, HIGHLIGHT_PADDING)
	%LineHighlight.position = line_rect.position - padding
	%LineHighlight.size = line_rect.size + padding * 2
	%LineHighlight.show()
	get_line_label(line_index).add_theme_color_override("font_color", highlight_color)


func get_line_label(line_index: int) -> Label:
	if line_index < BOARD_SIZE:
		return row_labels[line_index]

	return column_labels[line_index - BOARD_SIZE]


## Call right after score_line so last_line belongs to this line.
func record_line(line_name: String, label: Label) -> void:
	label.text = str(last_line["score"])

	var result = last_line.duplicate()
	result["name"] = line_name
	line_results.append(result)


func add_breakdown(source: String, change: String, reason := "") -> void:
	var entry = "%s: %s" % [source, change]

	if reason:
		entry += " (%s)" % reason

	line_breakdown.append(entry)


static func format_mult(mult: float) -> String:
	return str(snappedf(mult, 0.01))


func evaluate_hand(line: Array) -> Hand:
	var cards = line.filter(func(card): return card != null)

	if cards.is_empty():
		return Hand.NONE

	var rank_counts = {}
	for card in cards:
		var rank = card.rank
		rank_counts[rank] = rank_counts.get(rank, 0) + 1

	var counts = rank_counts.values()
	counts.sort()
	counts.reverse()

	var is_flush = false
	var is_straight = false
	if cards.size() == BOARD_SIZE:
		is_flush = cards.all(func(card): return card.suit == cards[0].suit)
		is_straight = check_straight(rank_counts.keys())

	if is_straight and is_flush:
		if rank_counts.has(10) and rank_counts.has(14):
			return Hand.ROYAL_FLUSH

		return Hand.STRAIGHT_FLUSH

	if counts[0] == 4:
		return Hand.FOUR_OF_A_KIND

	if counts[0] == 3 and counts.size() > 1 and counts[1] == 2:
		return Hand.FULL_HOUSE

	if is_flush:
		return Hand.FLUSH

	if is_straight:
		return Hand.STRAIGHT

	if counts[0] == 3:
		return Hand.THREE_OF_A_KIND

	if counts[0] == 2 and counts.size() > 1 and counts[1] == 2:
		return Hand.TWO_PAIR

	if counts[0] == 2:
		return Hand.PAIR

	return Hand.HIGH_CARD


func check_straight(ranks: Array) -> bool:
	if ranks.size() != BOARD_SIZE:
		return false

	ranks.sort()

	if ranks[4] - ranks[0] == 4:
		return true

	return ranks == [2, 3, 4, 5, 14] # ace-low


# Card data, set by the Deck when a card is drawn

func get_cards_of_rank(cards: Array, rank: int) -> Array:
	return cards.filter(func(card): return card.rank == rank)


func get_cards_of_suit(cards: Array, suit: String) -> Array:
	return cards.filter(func(card): return card.suit == suit)


# A pair or better, the hands that reward descriptions call a "scoring hand"
func is_scoring_hand(hand: Hand) -> bool:
	return HAND_POINTS[hand] > 0


# Boss debuffs, from the current boss in $"../Boss"

func apply_debuffs_to_points(cards: Array, _hand: Hand, points: float) -> float:
	var boss = $"../Boss"

	if boss.get_debuff_type() == "tile_penalty":
		var affected_cards = cards.filter(func(card): return boss.is_tile_affected(card.tile_index))

		if not affected_cards.is_empty():
			var penalty = affected_cards.size() * TILE_PENALTY_POINTS
			points -= penalty
			add_breakdown(boss.current_boss["name"], "-%d points" % penalty, "%d on affected tiles" % affected_cards.size())

	if boss.get_debuff_type() == "suit_debuff" and not get_cards_of_suit(cards, boss.current_boss["suit"]).is_empty():
		# Rounded down so the points box always shows a whole number
		points = floorf(points * SUIT_DEBUFF_MULTIPLIER)
		add_breakdown(boss.current_boss["name"], "x%s points" % format_mult(SUIT_DEBUFF_MULTIPLIER), "contains %s" % boss.current_boss["suit"])

	return points


func apply_debuffs_to_mult(_cards: Array, _hand: Hand, mult: float) -> float:
	return mult


# Card modifiers, from the rewards collected this run

func apply_modifiers_to_points(cards: Array, hand: Hand, points: float) -> float:
	if not is_scoring_hand(hand):
		return points

	var active_modifiers = $"../RewardsManager".player_rewards

	for modifier in active_modifiers:
		match modifier["type"]:
			"suit_bonus":
				# Each card of the suit adds the number of cards of that suit in the hand
				var suit_cards = get_cards_of_suit(cards, modifier["suit"])
				var bonus = 0
				var reversed_count = 0

				for card in suit_cards:
					if is_modifier_reversed([card]):
						bonus -= suit_cards.size()
						reversed_count += 1
					else:
						bonus += suit_cards.size()

				if not suit_cards.is_empty():
					points += bonus
					add_breakdown(modifier["name"], "%+d points" % bonus, get_reversed_reason(reversed_count))
			"rank_bonus":
				var rank_cards = get_cards_of_rank(cards, modifier["rank"])
				if not rank_cards.is_empty():
					var is_reversed = is_modifier_reversed(rank_cards)
					var bonus = - RANK_BONUS_POINTS if is_reversed else RANK_BONUS_POINTS
					points += bonus
					add_breakdown(modifier["name"], "%+d points" % bonus, get_reversed_reason(1 if is_reversed else 0))

	return points


func apply_modifiers_to_mult(cards: Array, hand: Hand, mult: float) -> float:
	if not is_scoring_hand(hand):
		return mult

	var active_modifiers = $"../RewardsManager".player_rewards

	for modifier in active_modifiers:
		match modifier["type"]:
			"rank_multiplier":
				var rank_cards = get_cards_of_rank(cards, modifier["rank"])
				if not rank_cards.is_empty():
					if is_modifier_reversed(rank_cards):
						mult /= RANK_MULTIPLIER
						add_breakdown(modifier["name"], "/%s mult" % format_mult(RANK_MULTIPLIER), get_reversed_reason(1))
					else:
						mult *= RANK_MULTIPLIER
						add_breakdown(modifier["name"], "x%s mult" % format_mult(RANK_MULTIPLIER))

	return mult


func get_reversed_reason(reversed_count: int) -> String:
	if reversed_count == 0:
		return ""

	return "%d reversed by %s" % [reversed_count, $"../Boss".current_boss["name"]]


## Angry Ghost: a modifier is reversed when a card that triggers it sits on an affected tile.
func is_modifier_reversed(triggering_cards: Array) -> bool:
	var boss = $"../Boss"

	if boss.get_debuff_type() != "reverse_modifiers":
		return false

	return triggering_cards.any(func(card): return boss.is_tile_affected(card.tile_index))


func play_scoring_sfx(score: int, pitch: float):
	if score > 0:
		play_score_sfx(DOUBLE_COIN_FX if score > HAND_POINTS[Hand.FOUR_OF_A_KIND] else SINGLE_COIN_FX, pitch)


func play_score_sfx(stream: AudioStream, pitch: float):
	$ScoreSFX.stream = stream
	$ScoreSFX.pitch_scale = pitch
	$ScoreSFX.play()

	await get_tree().create_timer(stream.get_length() + 0.1).timeout
