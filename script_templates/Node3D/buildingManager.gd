extends Node3D

func _ready():
	for child in get_children():
		if child is MeshInstance3D:
			var child_name = child.name.to_lower()  # Case-insensitive check
			
			if child_name.begins_with("pass_"):
				continue  # No collision, normal render
			elif child_name.begins_with("arrow"):
				var area := add_Area3D_colision_to_mesh(child)
				area.connect("body_entered", Callable(self, "_on_arrow_body_entered").bind(area))
				area.collision_mask = GameState.PLAYER  # This makes it detect layer 1 bodies (e.g. player)
			else:
				add_StaticBody3D_colision_to_mesh(child)  # Default: add collision

func add_StaticBody3D_colision_to_mesh(mesh_instance: MeshInstance3D):
	var static_body = StaticBody3D.new()
	mesh_instance.add_child(static_body)
	static_body.owner = get_tree().current_scene

	var collision_shape = CollisionShape3D.new()
	static_body.add_child(collision_shape)

	if mesh_instance.mesh:
		var shape = mesh_instance.mesh.create_trimesh_shape()
		if shape:
			collision_shape.shape = shape
		else:
			print("Failed to create collision for: ", mesh_instance.name)

func add_Area3D_colision_to_mesh(mesh_instance: MeshInstance3D) -> Area3D:
	var area = Area3D.new()
	mesh_instance.add_child(area)
	area.owner = get_tree().current_scene

	var collision_shape = CollisionShape3D.new()
	area.add_child(collision_shape)

	if mesh_instance.mesh:
		var shape = mesh_instance.mesh.create_trimesh_shape()
		if shape:
			collision_shape.shape = shape
		else:
			print("Failed to create collision shape for arrow: ", mesh_instance.name)
	return area

func _on_arrow_body_entered(body: Node3D, arrow: Area3D):
	if body.is_in_group("player"):
		print("Welcome to Chalmers")
		GameState.add_score(1)
		var arrow_mesh = arrow.get_parent()

		# Immediately free all children of arrow_mesh
		for child in arrow_mesh.get_children():
			child.queue_free()

		#keep the visual arrow on the screen for one second to not be jarring
		await get_tree().create_timer(1.0).timeout
		arrow_mesh.queue_free()
	else:
		print("[BuildManager] arrow already entered")
