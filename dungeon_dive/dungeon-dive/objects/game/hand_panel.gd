extends Control


const ON_BOARD_COLOR = Color.WHITE
const OFF_BOARD_COLOR = Color(0.55, 0.55, 0.55)


var line_results := []
# Index into line_results (rows 1-5 then columns 1-5), -1 when no score is hovered
var hovered_index := -1
var hand_counts := {}
# Hand -> [name label, points label, count label]
var hand_rows := {}


func _ready() -> void:
	# Best hand first, an empty line is not a hand
	var hands = ScoreManager.HAND_POINTS.keys()
	hands.erase(ScoreManager.Hand.NONE)
	hands.sort()
	hands.reverse()

	for hand in hands:
		# Table labels in hand_panel.tscn are named after the hand, e.g. ThreeOfAKindName
		var row_name = ScoreManager.Hand.keys()[hand].to_pascal_case()
		hand_rows[hand] = [
			%HandTable.get_node(row_name + "Name"),
			%HandTable.get_node(row_name + "Points"),
			%HandTable.get_node(row_name + "Count"),
		]
		hand_rows[hand][0].text = ScoreManager.HAND_NAMES[hand]
		hand_rows[hand][1].text = str(ScoreManager.HAND_POINTS[hand])

	refresh()


# Called by the ScoreManager every time the board is scored
func update_board(results: Array) -> void:
	line_results = results
	hand_counts.clear()

	for result in line_results:
		hand_counts[result["hand"]] = hand_counts.get(result["hand"], 0) + 1

	refresh()


func open_line(line_index: int) -> void:
	hovered_index = line_index
	%ScoringButton.button_pressed = true
	refresh()


func _on_scoring_button_toggled(toggled_on: bool) -> void:
	%ScoringPanel.visible = toggled_on
	refresh()


func hover_line(line_index: int) -> void:
	hovered_index = line_index
	refresh()


func end_hover() -> void:
	hovered_index = -1
	refresh()


func refresh() -> void:
	var index = hovered_index
	var shown_hand = -1

	if index >= line_results.size():
		index = -1

	$"../ScoreManager".highlight_line(index if %ScoringPanel.visible else -1)

	if index == -1:
		%LineLabel.text = "No line selected"
		%HandNameLabel.text = "-"
		%PointsLabel.text = "0"
		%MultLabel.text = "1"
		%LineScoreLabel.text = "= 0"
		%BreakdownLabel.text = "Hover the score at the end of a row or column to see how it was scored."
		%LineLabel.remove_theme_color_override("font_color")
	else:
		var result = line_results[index]
		shown_hand = result["hand"]
		%LineLabel.text = result["name"]
		%LineLabel.add_theme_color_override("font_color", $"../ScoreManager".highlight_color)
		%HandNameLabel.text = ScoreManager.HAND_NAMES[shown_hand]
		%PointsLabel.text = str(result["points"])
		%MultLabel.text = ScoreManager.format_mult(result["mult"])
		%LineScoreLabel.text = "= %d" % result["score"]
		%BreakdownLabel.text = "\n".join(PackedStringArray(result["breakdown"]))

	for hand in hand_rows:
		var count = hand_counts.get(hand, 0)
		var color = OFF_BOARD_COLOR

		if hand == shown_hand:
			color = $"../ScoreManager".highlight_color
		elif count > 0:
			color = ON_BOARD_COLOR

		hand_rows[hand][2].text = "x%d" % count if count > 0 else ""

		for label in hand_rows[hand]:
			label.add_theme_color_override("font_color", color)
