extends Node3D

func _ready():
	for child in get_children():
		if child is MeshInstance3D:
			var child_name = child.name.to_lower()  # Case-insensitive check
			
			if child_name.begins_with("pass_"):
				continue  # No collision, normal render
			else:
				add_collision_to_mesh(child)  # Default: add collision

func add_collision_to_mesh(mesh_instance: MeshInstance3D):
	var static_body = StaticBody3D.new()
	mesh_instance.add_child(static_body)
	static_body.owner = get_tree().current_scene

	var collision_shape = CollisionShape3D.new()
	static_body.add_child(collision_shape)

	if mesh_instance.mesh:
		if mesh_instance.name.to_lower() == "passmap_24_osm_roads_unclassified" or mesh_instance.name.to_lower() == "passmap_22_osm_vegetation":
			return
		var shape = mesh_instance.mesh.create_trimesh_shape()
		if shape:
			collision_shape.shape = shape
		else:
			print("Failed to create collision for: ", mesh_instance.name)
