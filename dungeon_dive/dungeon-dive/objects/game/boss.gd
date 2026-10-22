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

	for tile in get_tree().get_nodes_in_group("tiles"):
		tile.set_affected(is_tile_affected(int(tile.name.trim_prefix("Tile"))))

	%BossNameLabel.text = current_boss["name"]
	%BossDescriptionLabel.text = current_boss["description"]


func get_debuff_type() -> String:
	return current_boss.get("type", "")


func is_tile_affected(tile_index: int) -> bool:
	return affected_tiles.has(tile_index)
