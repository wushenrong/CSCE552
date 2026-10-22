extends Node2D


var update_score_board: Callable


func _ready() -> void:
	if update_score_board:
		$ScoreManager.on_board_scored.connect(update_score_board)
