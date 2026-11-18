extends Tool


func use() -> void:
	# TODO: implement
	pass


func disable_collision():
	$CollisionPolygon3D.disabled = true


func enable_collision():
	$CollisionPolygon3D.disabled = false
