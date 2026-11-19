extends Node3D

@export var slice_spacing: float = 0.1
@export var slice_edge_margin: float = 0.01
@export var intersection_epsilon: float = 0.0001
@export var point_merge_tolerance: float = 0.001

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

	if slice_spacing <= 0.0:
		print("ERROR: Slice spacing must be greater than zero")
		return

	print("Cave Space mesh loaded")
	print("Triangle count: ", get_triangle_count(cave_mesh.mesh))
	print("Mesh bounds: ", cave_mesh.get_aabb())
	print("CaveSpace mesh global position: ", cave_mesh.global_position)
	print("CaveSpace root global position: ", global_position)

	generate_all_slices()


func get_triangle_count(mesh: Mesh) -> int:
	return floori(mesh.get_faces().size() / 3.0)


func generate_all_slices() -> void:
	var bounds = cave_mesh.get_aabb()

	var min_height = bounds.position.y + slice_edge_margin
	var max_height = bounds.end.y - slice_edge_margin

	print("")
	print("========== GENERATING SLICES ==========")
	print("Lowest slice: ", min_height)
	print("Highest slice: ", max_height)
	print("Slice spacing: ", slice_spacing)

	var height = min_height
	var slice_number = 0

	while height <= max_height:
		print_horizontal_slice(height, slice_number)

		height += slice_spacing
		slice_number += 1

	print("Total slices generated: ", slice_number)
	print("=======================================")


func print_horizontal_slice(
	slice_height: float,
	slice_number: int
) -> void:
	var faces = cave_mesh.mesh.get_faces()
	var plane_y = cave_mesh.global_position.y + slice_height

	var points: Array[Vector3] = []
	var segments: Array[Vector2i] = []

	print("")
	print("========== SLICE ", slice_number, " ==========")
	print("Slice height: ", slice_height)
	print("World plane Y: ", plane_y)

	for i in range(0, faces.size(), 3):
		var a = cave_mesh.to_global(faces[i])
		var b = cave_mesh.to_global(faces[i + 1])
		var c = cave_mesh.to_global(faces[i + 2])

		var intersections = intersect_triangle_with_plane(
			a, b, c, plane_y
		)

		if intersections.size() == 2:
			var point_a = find_or_add_point(points, intersections[0])
			var point_b = find_or_add_point(points, intersections[1])

			if point_a == point_b:
				continue

			var segment = Vector2i(
				min(point_a, point_b),
				max(point_a, point_b)
			)

			if not segments.has(segment):
				segments.append(segment)

	print("Unique intersection points: ", points.size())
	print("Unique intersection segments: ", segments.size())

	build_outlines(points, segments, slice_height, slice_number)


func intersect_triangle_with_plane(
	a: Vector3,
	b: Vector3,
	c: Vector3,
	plane_y: float
) -> Array[Vector3]:
	var vertices = [a, b, c]
	var points: Array[Vector3] = []

	for i in range(3):
		var start: Vector3 = vertices[i]
		var end: Vector3 = vertices[(i + 1) % 3]

		var start_distance = start.y - plane_y
		var end_distance = end.y - plane_y

		# Both vertices are on the plane.
		# Ignore this edge here because its neighboring
		# triangles will also encounter the same edge.
		if (
			abs(start_distance) <= intersection_epsilon
			and abs(end_distance) <= intersection_epsilon
		):
			continue

		# One vertex is on the plane.
		if abs(start_distance) <= intersection_epsilon:
			add_unique_point(points, start)

		# The edge crosses the plane.
		elif (
			(start_distance < -intersection_epsilon
				and end_distance > intersection_epsilon)
			or
			(start_distance > intersection_epsilon
				and end_distance < -intersection_epsilon)
		):
			var weight = start_distance / (
				start_distance - end_distance
			)

			var intersection = start.lerp(end, weight)
			add_unique_point(points, intersection)

	# A triangle-plane intersection should produce
	# exactly two unique points to form a segment.
	if points.size() != 2:
		points.clear()

	return points


func add_unique_point(
	points: Array[Vector3],
	new_point: Vector3
) -> void:
	for existing_point in points:
		if existing_point.distance_to(new_point) <= intersection_epsilon:
			return

	points.append(new_point)


func find_or_add_point(
	points: Array[Vector3],
	new_point: Vector3
) -> int:
	for i in range(points.size()):
		if points[i].distance_to(new_point) <= point_merge_tolerance:
			return i

	points.append(new_point)
	return points.size() - 1


func build_outlines(
	points: Array[Vector3],
	segments: Array[Vector2i],
	slice_height: float,
	slice_number: int
) -> void:
	var connections: Array = []

	for i in range(points.size()):
		connections.append([])

	for i in range(segments.size()):
		var segment = segments[i]
		connections[segment.x].append(i)
		connections[segment.y].append(i)

	# Connection diagnostics
	var degree_zero := 0
	var degree_one := 0
	var degree_two := 0
	var degree_other := 0

	for i in range(connections.size()):
		var degree = connections[i].size()

		if degree == 0:
			degree_zero += 1
		elif degree == 1:
			degree_one += 1
			print("ENDPOINT at ", points[i], " | Connections: ", degree)
		elif degree == 2:
			degree_two += 1
		else:
			degree_other += 1
			print("BRANCH at ", points[i], " | Connections: ", degree)

	print("----- CONNECTION DIAGNOSTICS -----")
	print("Points with 0 connections: ", degree_zero)
	print("Points with 1 connection: ", degree_one)
	print("Points with 2 connections: ", degree_two)
	print("Points with more than 2 connections: ", degree_other)
	print("----------------------------------")

	var used_segments: Array[bool] = []

	for i in range(segments.size()):
		used_segments.append(false)

	var outline_number = 0

	for i in range(segments.size()):
		if used_segments[i]:
			continue

		var first_segment = segments[i]
		var start_point = first_segment.x
		var current_point = first_segment.y

		var outline: Array[int] = [
			start_point,
			current_point
		]

		used_segments[i] = true
		var closed = false

		while true:
			if current_point == start_point:
				closed = true
				break

			var next_segment_index = -1

			for connected_segment in connections[current_point]:
				if not used_segments[connected_segment]:
					next_segment_index = connected_segment
					break

			if next_segment_index == -1:
				break

			used_segments[next_segment_index] = true
			var next_segment = segments[next_segment_index]

			if next_segment.x == current_point:
				current_point = next_segment.y
			else:
				current_point = next_segment.x

			outline.append(current_point)

		outline_number += 1

		if closed:
			print("Outline ", outline_number, ": CLOSED | Points: ", outline.size())
			outline.pop_back()

			triangulate_outline(
				points,
				outline,
				slice_height,
				slice_number
			)
		else:
			print("Outline ", outline_number, ": OPEN | Points: ", outline.size())

	print("Total outlines found: ", outline_number)


func triangulate_outline(
	points: Array[Vector3],
	outline: Array[int],
	slice_height: float,
	slice_number: int
) -> void:
	if outline.size() < 3:
		print("ERROR: Not enough points to triangulate")
		return

	var polygon := PackedVector2Array()

	for point_index in outline:
		var point = points[point_index]
		polygon.append(Vector2(point.x, point.z))

	var triangle_indices = Geometry2D.triangulate_polygon(polygon)

	if triangle_indices.is_empty():
		print("ERROR: Polygon triangulation failed")
		return

	print("Polygon vertices: ", polygon.size())
	print("Interior triangles: ", triangle_indices.size() / 3)

	create_slice_visualization(
		polygon,
		triangle_indices,
		slice_height,
		slice_number
	)


func create_slice_visualization(
	polygon: PackedVector2Array,
	triangle_indices: PackedInt32Array,
	slice_height: float,
	slice_number: int
) -> void:
	var vertices := PackedVector3Array()

	for index in triangle_indices:
		var point = polygon[index]

		vertices.append(
			Vector3(
				point.x - global_position.x,
				0.0,
				point.y - global_position.z
			)
		)

	var mesh := ArrayMesh.new()
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	var visual := MeshInstance3D.new()
	visual.name = "SliceVisualization_" + str(slice_number)
	visual.mesh = mesh
	visual.top_level = false

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.0, 0.0, 1.0)
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.no_depth_test = true

	visual.material_override = material

	add_child(visual)

	visual.visible = false
	visible = true

	visual.position.y = (
		cave_mesh.global_position.y
		+ slice_height
		- global_position.y
	)

	print("Visualization created: ", visual.name)
	print("Visualization visible: ", visual.is_visible_in_tree())
	print("Visualization triangles: ", triangle_indices.size() / 3)
