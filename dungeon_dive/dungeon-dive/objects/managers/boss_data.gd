extends Node

# Debuff values live in ScoreManager, keep the descriptions in sync with them
const BOSSES = {
	"angry_ghost": {
		"id": "angry_ghost",
		"name": "Angry Ghost",
		"type": "reverse_modifiers",
		"tile_count": 8,
		"icon": "angry_ghost",
		"description": "Reward modifiers on affected (red) tiles are reversed."
	},
	"restless_skeleton": {
		"id": "restless_skeleton",
		"name": "Restless Skeleton",
		"type": "tile_penalty",
		"tile_count": 6,
		"icon": "restless_skeleton",
		"description": "Each card on an affected (red) tile removes 3 points from its row and column."
	},
	"heartless_wraith": {
		"id": "heartless_wraith",
		"name": "Heartless Wraith",
		"type": "suit_debuff",
		"suit": "Hearts",
		"icon": "heartless_wraith",
		"description": "Hands containing a Heart score half points."
	},
}

func get_boss(boss_id: String) -> Dictionary:
	if BOSSES.has(boss_id):
		return BOSSES[boss_id].duplicate(true)

	return {}

func get_random_boss_id() -> String:
	return BOSSES.keys().pick_random()
