extends Tool


signal deposit_requested(origin: Vector3, target: Vector3)


@export var camera: Camera3D
@export var player_body: CollisionObject3D
@export var deposit_range: float = 5.0


@onready var nozzle_tip: Marker3D = $NozzleTip


func use(animation_player: AnimationPlayer) -> void:
	print("1. Nozzle use started")

	if camera == null:
		print("2. ERROR: Camera is not assigned")
		return

	print("3. Camera assigned: ", camera.name)

	if player_body == null:
		print("4. WARNING: Player body is not assigned")
	else:
		print("4. Player body assigned: ", player_body.name)

	print("5. Starting raycast")

	var screen_center = get_viewport().get_visible_rect().size / 2.0
	var ray_origin = camera.project_ray_origin(screen_center)
	var ray_direction = camera.project_ray_normal(screen_center)
	var ray_end = ray_origin + ray_direction * deposit_range

	var query = PhysicsRayQueryParameters3D.create(
		ray_origin,
		ray_end
	)

	if player_body != null:
		query.exclude = [player_body.get_rid()]

	var space_state = get_world_3d().direct_space_state
	var hit = space_state.intersect_ray(query)

	print("6. Raycast completed")

	if hit.is_empty():
		print("7. No surface found")
		return

	print("8. Surface hit: ", hit["position"])

	var nozzle_origin = nozzle_tip.global_position
	var target_position: Vector3 = hit["position"]

	deposit_requested.emit(nozzle_origin, target_position)

	print("Nozzle origin: ", nozzle_origin)
	print("Target position: ", target_position)
