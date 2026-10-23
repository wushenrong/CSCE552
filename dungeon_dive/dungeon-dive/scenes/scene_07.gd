extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Table labels in scene_07.tscn are named after the hand, e.g. ThreeOfAKindName
	for hand in ScoreManager.HAND_POINTS:
		if hand == ScoreManager.Hand.NONE:
			continue

		var row_name = ScoreManager.Hand.keys()[hand].to_pascal_case()
		%HandTable.get_node(row_name + "Name").text = ScoreManager.HAND_NAMES[hand]
		%HandTable.get_node(row_name + "Points").text = str(ScoreManager.HAND_POINTS[hand])


func _on_rules_button_pressed() -> void:
	show()


func _on_back_button_pressed() -> void:
	hide()
