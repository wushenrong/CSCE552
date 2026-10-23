extends Node


const TILE_COUNT = 25


var current_boss := {}
var affected_tiles := []


func roll_boss() -> void:
	current_boss = BossData.get_boss(BossData.get_random_boss_id())
	affected_tiles.clear()

	if current_boss.has("tile_count"):
		var tile_indices = range(TILE_COUNT)
		tile_indices.shuffle()
		affected_tiles = tile_indices.slice(0, current_boss["tile_count"])

	show_boss()


# Marks the affected tiles and fills in the BossPanel for the current boss
func show_boss() -> void:
	for tile in get_tree().get_nodes_in_group("tiles"):
		tile.set_affected(is_tile_affected(int(tile.name.trim_prefix("Tile"))))

	%BossNameLabel.text = current_boss["name"]
	%BossDescriptionLabel.text = current_boss["description"]


func get_debuff_type() -> String:
	return current_boss.get("type", "")


func is_tile_affected(tile_index: int) -> bool:
	return affected_tiles.has(tile_index)


# Only the ID is saved, the rest of the boss comes from BossData
func get_save_data() -> Dictionary:
	return {
		"boss_id": current_boss["id"],
		"affected_tiles": affected_tiles,
	}


func load_save_data(data: Dictionary) -> void:
	current_boss = BossData.get_boss(data["boss_id"])

	# The boss was removed or renamed since the save was made
	if current_boss.is_empty():
		push_warning("Unknown boss ID: " + data["boss_id"])
		roll_boss()
		return

	affected_tiles = data["affected_tiles"]
	show_boss()
