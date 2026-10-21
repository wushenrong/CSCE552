extends Node2D
## Scores the 5x5 board: 5 rows + 5 columns, each scored as a poker hand.
## line score = points (American Poker Squares) x mult


const SINGLE_COIN_FX = preload("res://assets/sound_effects/single_coin_falling_fx.wav")
const DOUBLE_COIN_FX = preload("res://assets/sound_effects/double_coins_falling_fx.wav")
const COINS_FALLING_FX = preload("res://assets/sound_effects/coins_falling_fx.wav")


const BOARD_SIZE = 5

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


## board: 25 cards in row order (index = row * 5 + col), null for an empty tile.
func score_board(board: Array) -> int:
	var total = 0
	var pitch = 1.0

	for i in BOARD_SIZE:
		total += score_line(get_row(board, i))
		play_score_sfx(SINGLE_COIN_FX, pitch)
		pitch += 0.2

		total += score_line(get_column(board, i))
		play_score_sfx(DOUBLE_COIN_FX, pitch)
		pitch += 0.2

	play_score_sfx(COINS_FALLING_FX, 1.0)
	%ScoreLabel.text = "Score: %d" % total

	return total


func score_line(cards: Array) -> int:
	var hand = evaluate_hand(cards)
	var points = HAND_POINTS[hand]
	var mult = 1.0

	# TODO: boss debuffs and card modifiers
	points = apply_debuffs_to_points(cards, hand, points)
	mult = apply_debuffs_to_mult(cards, hand, mult)
	points = apply_modifiers_to_points(cards, hand, points)
	mult = apply_modifiers_to_mult(cards, hand, mult)

	return max(int(points * mult), 0)


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


func evaluate_hand(line: Array) -> Hand:
	var cards = line.filter(func(card): return card != null)
	if cards.is_empty():
		return Hand.NONE

	var rank_counts = {}
	for card in cards:
		var rank = card.get_rank()
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


# To be defined: boss debuffs

func apply_debuffs_to_points(_cards: Array, _hand: Hand, points: float) -> float:
	return points


func apply_debuffs_to_mult(_cards: Array, _hand: Hand, mult: float) -> float:
	return mult


# To be defined: card modifiers

func apply_modifiers_to_points(_cards: Array, _hand: Hand, points: float) -> float:
	return points


func apply_modifiers_to_mult(_cards: Array, _hand: Hand, mult: float) -> float:
	return mult


func play_score_sfx(stream: AudioStream, pitch: float):
	$ScoreSFX.stream = stream
	$ScoreSFX.pitch_scale = pitch
	$ScoreSFX.play()
	await get_tree().create_timer(stream.get_length() + 0.1).timeout
