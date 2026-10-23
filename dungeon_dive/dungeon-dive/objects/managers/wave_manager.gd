extends Node2D


signal wave_cleared
signal wave_failed


const BASE_POINT_GOAL = 30
const POINT_GOAL_PER_WAVE = 15


var wave := 1
var point_goal := 0


# Called by the Board when a new run starts, a continued run uses load_save_data instead
func start_wave() -> void:
	$"../Boss".roll_boss()
	update_wave()


# Sets the goal and scores the board, the boss for this wave must already be set
func update_wave() -> void:
	point_goal = BASE_POINT_GOAL + (wave - 1) * POINT_GOAL_PER_WAVE
	PlayerSettings.update_highest_wave(wave)
	$"../ScoreManager".score_board($"../CardManager".board_cards)

	%WaveLabel.text = "Wave %d" % wave
	%GoalLabel.text = "Goal: %d" % point_goal


func end_wave(total: int) -> void:
	if total >= point_goal:
		wave_cleared.emit(wave, $"../RewardsManager".get_rewards())
		$WinSFX.play()
	else:
		wave_failed.emit(wave, $"../RewardsManager".get_rewards())


# Connected to the RewardsMenu's closed signal in scene_04
func start_next_wave() -> void:
	wave += 1
	$"../CardManager".clear_board()
	$"../Deck".reset_deck()
	start_wave()


func get_save_data() -> Dictionary:
	return {"wave": wave}


func load_save_data(data: Dictionary) -> void:
	wave = data["wave"]
	update_wave()
