extends CanvasLayer


signal reward_chosen
signal closed


# Reward IDs on RewardButton0-2, in button order
var offered_ids := []


func _on_wave_cleared(wave: int, owned_rewards: Array) -> void:
	var owned_ids = owned_rewards.map(func(reward): return reward["id"])
	var available_ids = RewardData.REWARDS.keys().filter(func(reward_id): return not owned_ids.has(reward_id))
	available_ids.shuffle()

	# Every reward is already collected, go straight to the next wave
	if available_ids.is_empty():
		closed.emit()
		return

	var reward_buttons = %RewardContainer.get_children()
	offered_ids = available_ids.slice(0, reward_buttons.size())

	for i in reward_buttons.size():
		reward_buttons[i].visible = i < offered_ids.size()

		if reward_buttons[i].visible:
			var reward = RewardData.get_reward(offered_ids[i])
			reward_buttons[i].text = "%s\n\n%s" % [reward["name"], reward["description"]]

	%WaveClearedLabel.text = "Wave %d Cleared! Choose a Reward" % wave
	get_tree().paused = true
	show()


# button_index is bound on each RewardButton's connection in scene_05.tscn
func _on_reward_button_pressed(button_index: int) -> void:
	hide()
	get_tree().paused = false
	reward_chosen.emit(offered_ids[button_index])
	closed.emit()
