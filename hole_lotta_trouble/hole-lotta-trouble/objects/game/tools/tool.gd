class_name Tool
extends StaticBody3D


@export var animation_name: String


func use(animation_player: AnimationPlayer) -> void:
	if animation_name and animation_player.has_animation(animation_name):
		if not animation_player.animation_finished.is_connected(_on_animation_finished):
			animation_player.animation_finished.connect(_on_animation_finished.bind())

		animation_player.play(animation_name)


func _on_animation_finished(_anim_name: String):
	pass
