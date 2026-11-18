extends Node3D

@onready var cave_mesh: MeshInstance3D = find_child(
	"*",
	true,
	false
)


func _ready() -> void:
	if cave_mesh == null:
		print("ERROR: Could not find Cave Space MeshInstance3D")
		return

	if cave_mesh.mesh == null:
		print("ERROR: Cave Space has no mesh resource")
		return

	var mesh: Mesh = cave_mesh.mesh

	print("Cave Space mesh loaded")
	print("Triangle count: ", get_triangle_count(mesh))
	print("Mesh bounds: ", cave_mesh.get_aabb())


func get_triangle_count(mesh: Mesh) -> int:
	var triangle_count = 0

	for surface in range(mesh.get_surface_count()):
		var arrays = mesh.surface_get_arrays(surface)
		var indices = arrays[Mesh.ARRAY_INDEX]

		if indices != null:
			triangle_count += indices.size() / 3
		else:
			var vertices = arrays[Mesh.ARRAY_VERTEX]
			triangle_count += vertices.size() / 3

	return triangle_count
