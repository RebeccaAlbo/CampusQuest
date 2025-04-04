extends Node3D

func _ready():
	for child in get_children():
		if child is MeshInstance3D:
			add_collision_to_mesh(child)

func add_collision_to_mesh(mesh_instance: MeshInstance3D):
	var static_body = StaticBody3D.new()  # Create a new StaticBody3D
	mesh_instance.add_child(static_body)
	static_body.owner = get_tree().current_scene  # Ensure it’s saved with the scene

	var collision_shape = CollisionShape3D.new()  # Create the CollisionShape3D
	static_body.add_child(collision_shape)

	var mesh = mesh_instance.mesh
	if mesh:
		# Create a trimesh collision shape from the mesh geometry
		var trimesh_shape = mesh.create_trimesh_shape()
		if trimesh_shape:
			collision_shape.shape = trimesh_shape
		else:
			print("Failed to create trimesh collision shape for:", mesh_instance.name)
