extends Node2D


signal rewards_changed


# Rewards collected during the current run.
var player_rewards := []


func add_reward_by_id(reward_id: String) -> void:
	var reward = RewardData.get_reward(reward_id)

	if reward.is_empty():
		push_warning("Unknown reward ID: " + reward_id)
		return

	# Prevent collecting the same reward twice.
	for existing_reward in player_rewards:
		if existing_reward["id"] == reward_id:
			push_warning("Reward already collected: " + reward_id)
			return

	player_rewards.append(reward)
	rewards_changed.emit()

func remove_reward_by_id(reward_id: String) -> void:
	for i in range(player_rewards.size()):
		if player_rewards[i]["id"] == reward_id:
			player_rewards.remove_at(i)
			rewards_changed.emit()
			return

func clear_rewards() -> void:
	player_rewards.clear()
	rewards_changed.emit()

func get_rewards() -> Array:
	return player_rewards.duplicate(true)


## ScoreManager change, replace the following in apply_mod_to_points AND apply_mod_to_mult:
## var active_modifiers = $"../RunRewards".active_modifiers
## to
## var active_modifiers = $"../RunRewards".player_rewards

func _ready() -> void:
	add_reward_by_id("radiant_seven")
	print("Initial reward added: ", player_rewards[0]["name"], " — ", player_rewards[0]["description"])
