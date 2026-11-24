extends Tool


func use(animation_player: AnimationPlayer) -> void:
	$CollisionPolygon3D.set_deferred("disabled", false)

	super(animation_player)


func _on_animation_finished(_anim_name: String):
	$CollisionPolygon3D.set_deferred("disabled", true)
