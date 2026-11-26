extends Node3D

@export var animation_player: AnimationPlayer

var current_tool_index: int = 0

@onready var tools = get_children() as Array[Tool]


func _ready() -> void:
	tools[current_tool_index].show()


func _unhandled_input(event: InputEvent) -> void:
	# Switch between equipped items
	if event.is_action_pressed("cycle_tool"):
		tools[current_tool_index].hide()

		current_tool_index = (current_tool_index + 1) % tools.size()

		tools[current_tool_index].show()

		print("Switched to: ", tools[current_tool_index].name)

	# Use the currently equipped item
	elif event.is_action_pressed("use_item"):
		var current_tool = tools[current_tool_index]
		print("Use item pressed")
		print("Using ", current_tool.name)
		current_tool.use(animation_player)

	# # Deposit material with the fill nozzle
	# elif event.is_action_pressed("deposit_material"):
	# 	if tools[current_tool_index] is:
	# 		print("Deposit button pressed")
	# 		fill_nozzle.use()
