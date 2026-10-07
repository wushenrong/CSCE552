extends Area2D

# Basic dragging from Godot Docs
@export var click_radius = 96
var dragging = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - self.position).length() < click_radius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			dragging = false

	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		self.position = event.position

	# TODO: Remove this branch and the following functions
	# if event.pressed:
	# 	raycast_check_for_card()
	# else:
	# 	print("Left Click Released")

func raycast_check_for_card():
	# Taken from Godot documentation
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	print("Mouse position: ", parameters.position)
	print(result)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
