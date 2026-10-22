extends CanvasLayer


@export var board: Node2D


func _ready() -> void:
	if board:
		board.update_score_board = update_score_board


func update_score_board(score: int):
	%ScoreLabel.text = "Score: %d" % score
