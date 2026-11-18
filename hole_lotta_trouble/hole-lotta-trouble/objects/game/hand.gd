extends Node3D

@onready var flashlight: Tool = $Flashlight
@onready var fill_nozzle: Tool = $FillNozzle

var tools: Array[Tool]
var current_tool_index: int = 0


func _ready() -> void:
    tools = [flashlight, fill_nozzle]
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

        if tools[current_tool_index] == flashlight:
            print("Using flashlight")
            flashlight.use()

        elif tools[current_tool_index] == fill_nozzle:
            print("Using fill nozzle")
            fill_nozzle.use()

    # Deposit material with the fill nozzle
    elif event.is_action_pressed("deposit_material"):
        if tools[current_tool_index] == fill_nozzle:
            print("Deposit button pressed")
            fill_nozzle.use()


func update_equipped_tool() -> void:
    for i in range(tools.size()):
        tools[i].visible = (i == current_tool_index)
