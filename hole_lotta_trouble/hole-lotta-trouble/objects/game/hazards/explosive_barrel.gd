extends Hazard

@onready var explosion_radius: Area3D = $ExplosionRadius


func explode():
	# $ExplosionSFX.play()
	var in_explosion = explosion_radius.get_overlapping_bodies()

	for node in in_explosion:
		print(node.name)
		var force_direction = (node.position - position).normalized()

		if node is RigidBody3D:
			node.apply_impulse(force_direction)

			# if node.has_method("explode"):
			# 	node.explode()

		if node is CharacterBody3D:
			node.velocity += force_direction * 200

	print("Barrel Exploded")

	queue_free()


func _on_body_entered(body: Node) -> void:
	if body is Tool:
		# TODO: Check if tool is only shovel or pickaxe and has been swang
		print(body.name)
		explode()

	# TODO: Check if body is world and should explode with enough force
