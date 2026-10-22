extends Node


signal choices_generated
signal reward_selected(reward: Dictionary)


const CHOICE_COUNT = 3


var available_choices := []


func generate_choices() -> void:
	available_choices.clear()

	var reward_ids = RewardData.REWARDS.keys()
	reward_ids.shuffle()

	var choice_count = min(CHOICE_COUNT, reward_ids.size())

	for i in range(choice_count):
		var reward_id = reward_ids[i]
		available_choices.append(RewardData.get_reward(reward_id))

	choices_generated.emit()

func select_reward(reward_id: String) -> void:
	for reward in available_choices:
		if reward["id"] == reward_id:
			var run_rewards = get_parent().get_node("RunRewards")
			run_rewards.add_reward_by_id(reward_id)

			available_choices.clear()
			reward_selected.emit(reward)
			return

# Testing function to generate choices and print them to the console
# func _ready() -> void:
# 	generate_choices()

# 	for reward in available_choices:
# 		print(reward["name"], " — ", reward["description"])
