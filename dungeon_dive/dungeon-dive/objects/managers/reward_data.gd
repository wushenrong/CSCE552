extends Node

const REWARDS = {
	"heart_of_hearts": {
		"id": "heart_of_hearts",
		"name": "Heart of Hearts",
		"type": "suit_bonus",
		"suit": "hearts",
		"icon": "heart_of_hearts",
		"description": "Each Heart in a scoring hand gives additional points equal to the total number of Hearts in that hand."
	},
	"club_of_clubs": {
		"id": "club_of_clubs",
		"name": "Club of Clubs",
		"type": "suit_bonus",
		"suit": "clubs",
		"icon": "club_of_clubs",
		"description": "Each Club in a scoring hand gives additional points equal to the total number of Clubs in that hand."
	},
	"spade_of_spades": {
		"id": "spade_of_spades",
		"name": "Spade of Spades",
		"type": "suit_bonus",
		"suit": "spades",
		"icon": "spade_of_spades",
		"description": "Each Spade in a scoring hand gives additional points equal to the total number of Spades in that hand."
	},
	"diamond_of_diamonds": {
		"id": "diamond_of_diamonds",
		"name": "Diamond of Diamonds",
		"type": "suit_bonus",
		"suit": "diamonds",
		"icon": "diamond_of_diamonds",
		"description": "Each Diamond in a scoring hand gives additional points equal to the total number of Diamonds in that hand."
	},
	"happy_jack": {
		"id": "happy_jack",
		"name": "Happy Jack",
		"type": "rank_multiplier",
		"rank": 11,
		"icon": "happy_jack",
		"description": "Multiply the score of a hand containing a Jack by 1.1."
	},
	"happy_queen": {
		"id": "happy_queen",
		"name": "Happy Queen",
		"type": "rank_multiplier",
		"rank": 12,
		"icon": "happy_queen",
		"description": "Multiply the score of a hand containing a Queen by 1.1."
	},
	"happy_king": {
		"id": "happy_king",
		"name": "Happy King",
		"type": "rank_multiplier",
		"rank": 13,
		"icon": "happy_king",
		"description": "Multiply the score of a hand containing a King by 1.1."
	},
	"happy_ace": {
		"id": "happy_ace",
		"name": "Happy Ace",
		"type": "rank_multiplier",
		"rank": 14,
		"icon": "happy_ace",
		"description": "Multiply the score of a hand containing an Ace by 1.1."
	},
	"radiant_jack": {
		"id": "radiant_jack",
		"name": "Radiant Jack",
		"type": "rank_bonus",
		"rank": 11,
		"icon": "radiant_jack",
		"description": "Add 5 points to a scoring hand containing a Jack."
	},
	"radiant_queen": {
		"id": "radiant_queen",
		"name": "Radiant Queen",
		"type": "rank_bonus",
		"rank": 12,
		"icon": "radiant_queen",
		"description": "Add 5 points to a scoring hand containing a Queen."
	},
	"radiant_king": {
		"id": "radiant_king",
		"name": "Radiant King",
		"type": "rank_bonus",
		"rank": 13,
		"icon": "radiant_king",
		"description": "Add 5 points to a scoring hand containing a King."
	},
	"radiant_ace": {
		"id": "radiant_ace",
		"name": "Radiant Ace",
		"type": "rank_bonus",
		"rank": 14,
		"icon": "radiant_ace",
		"description": "Add 5 points to a scoring hand containing an Ace."
	},
	"radiant_two": {
		"id": "radiant_two",
		"name": "Radiant Two",
		"type": "rank_bonus",
		"rank": 2,
		"icon": "radiant_two",
		"description": "Add 5 points to a scoring hand containing a Two."
	},
	"radiant_three": {
		"id": "radiant_three",
		"name": "Radiant Three",
		"type": "rank_bonus",
		"rank": 3,
		"icon": "radiant_three",
		"description": "Add 5 points to a scoring hand containing a Three."
	},
	"radiant_four": {
		"id": "radiant_four",
		"name": "Radiant Four",
		"type": "rank_bonus",
		"rank": 4,
		"icon": "radiant_four",
		"description": "Add 5 points to a scoring hand containing a Four."
	},
	"radiant_five": {
		"id": "radiant_five",
		"name": "Radiant Five",
		"type": "rank_bonus",
		"rank": 5,
		"icon": "radiant_five",
		"description": "Add 5 points to a scoring hand containing a Five."
	},
	"radiant_six": {
		"id": "radiant_six",
		"name": "Radiant Six",
		"type": "rank_bonus",
		"rank": 6,
		"icon": "radiant_six",
		"description": "Add 5 points to a scoring hand containing a Six."
	},
	"radiant_seven": {
		"id": "radiant_seven",
		"name": "Radiant Seven",
		"type": "rank_bonus",
		"rank": 7,
		"icon": "radiant_seven",
		"description": "Add 5 points to a scoring hand containing a Seven."
	},
	"radiant_eight": {
		"id": "radiant_eight",
		"name": "Radiant Eight",
		"type": "rank_bonus",
		"rank": 8,
		"icon": "radiant_eight",
		"description": "Add 5 points to a scoring hand containing an Eight."
	},
	"radiant_nine": {
		"id": "radiant_nine",
		"name": "Radiant Nine",
		"type": "rank_bonus",
		"rank": 9,
		"icon": "radiant_nine",
		"description": "Add 5 points to a scoring hand containing a Nine."
	},
	"radiant_ten": {
		"id": "radiant_ten",
		"name": "Radiant Ten",
		"type": "rank_bonus",
		"rank": 10,
		"icon": "radiant_ten",
		"description": "Add 5 points to a scoring hand containing a Ten."
	},
}

func get_reward(reward_id: String) -> Dictionary:
	if REWARDS.has(reward_id):
		return REWARDS[reward_id].duplicate(true)

	return {}
