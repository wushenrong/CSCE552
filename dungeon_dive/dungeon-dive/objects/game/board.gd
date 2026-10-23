extends Node2D


var on_wave_cleared: Callable
var on_wave_failed: Callable


# Called after every child is ready, so the saved run can be put back on top of them
func _ready() -> void:
	var run = SaveManager.load_run()

	# Start on the main menu deletes the save, so a save here means Continue was pressed
	if run.is_empty():
		$WaveManager.start_wave()
	else:
		load_game(run)


# Called by the PauseMenu's Save & Exit button
func save_game() -> void:
	SaveManager.save_run({
		"wave": $WaveManager.get_save_data(),
		"boss": $Boss.get_save_data(),
		"rewards": $RewardsManager.get_save_data(),
		"deck": $Deck.get_save_data(),
		"cards": $CardManager.get_save_data(),
	})


func load_game(run: Dictionary) -> void:
	# Rewards and the boss change scoring, the WaveManager scores the board so it goes last
	$RewardsManager.load_save_data(run["rewards"])
	$Boss.load_save_data(run["boss"])
	$Deck.load_save_data(run["deck"])
	$CardManager.load_save_data(run["cards"])
	$WaveManager.load_save_data(run["wave"])


func _on_wave_manager_wave_cleared(wave: int, owned_rewards: Array) -> void:
	on_wave_cleared.call(wave, owned_rewards)


func _on_wave_manager_wave_failed(wave: int, owned_rewards: Array) -> void:
	# The run is over, there is nothing left to continue
	SaveManager.delete_save()
	on_wave_failed.call(wave, owned_rewards)


func _on_rewards_menu_closed() -> void:
	$WaveManager.start_next_wave()


func _on_rewards_menu_reward_chosen(reward: String) -> void:
	$RewardsManager.add_reward_by_id(reward)
