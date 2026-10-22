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


##func _test_rewards() -> void: () ✅
##	clear_rewards()

##	add_reward_by_id("heart_of_hearts")
##	add_reward_by_id("happy_jack")
##	add_reward_by_id("heart_of_hearts")

##	print("Reward count after adding: ", player_rewards.size())

##	remove_reward_by_id("happy_jack")

##	print("Reward count after removing: ", player_rewards.size())
##	print("Remaining reward: ", player_rewards[0]["name"])

##func _ready() -> void: ✅
##	_test_rewards()
