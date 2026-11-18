extends Node3D


@onready var tools: Array[Tool] = [$Flashlight, $FillNozzle]
var current_tool_index: int = 0


func _ready() -> void:
	update_equipped_tool()


func _unhandled_input(event: InputEvent) -> void:
	# Switch between equipped items
	if event.is_action_pressed("cycle_tool"):
		current_tool_index = (current_tool_index + 1) % tools.size()
		update_equipped_tool()
		print("Switched to: ", tools[current_tool_index].name)

	# Use the currently equipped item
	elif event.is_action_pressed("use_item"):
		print("Use item pressed")
		print("Using ", tools[current_tool_index].name)
		tools[current_tool_index].use()

	# # Deposit material with the fill nozzle
	# elif event.is_action_pressed("deposit_material"):
	# 	if tools[current_tool_index] is:
	# 		print("Deposit button pressed")
	# 		fill_nozzle.use()


func update_equipped_tool() -> void:
	for i in range(tools.size()):
		tools[i].visible = (i == current_tool_index)
