extends CharacterBody3D

signal died

const MAX_HEALTH = 100

@export var speed = 5.0
@export var jump_velocity = 4.5
@export var health = MAX_HEALTH

var should_regenerate_health = true
var mouse_sensitivity = 0.003

@onready var head: Node3D = $Head


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		head.rotate_x(-event.relative.y * mouse_sensitivity)

		head.rotation.x = clamp(head.rotation.x, -PI / 2, PI / 2)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func respawn(pos):
	position = pos
	health = MAX_HEALTH


func damage(hit_points):
	should_regenerate_health = false
	health -= hit_points

	if health <= 0:
		died.emit()
		return

	$RegenerationTimer.start()


func regenerate_health():
	health += clampi(health + 1, 0, MAX_HEALTH)


func _on_regeneration_timer_timeout() -> void:
	should_regenerate_health = true
