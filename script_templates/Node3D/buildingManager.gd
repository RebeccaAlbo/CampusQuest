extends Node3D

var debug_enabled := false  # Toggle this to enable/disable debugging

func _ready():
	for child in get_children():
		if child is MeshInstance3D:
			var child_name = child.name.to_lower()  # Case-insensitive check
			
			if child_name.begins_with("pass_"):
				if debug_enabled: print("[DEBUG] Skipping pass-through: %s" % child_name)
				continue

			elif child_name.begins_with("arrow"):
				var scene_name := get_tree().current_scene.name.to_lower()

				if scene_name.ends_with("lindholmen"):
					if MiniQuests.finished_quests.has("arrowLinholmen"):
						if debug_enabled: print("[DEBUG] ArrowLinholmen completed, freeing: %s" % child_name)
						child.queue_free()
					else:
						var area := add_Area3D_colision_to_mesh(child)
						area.connect("body_entered", Callable(self, "_on_arrow_body_entered").bind(area))
						area.collision_mask = GameState.PLAYER
						if debug_enabled: print("[DEBUG] Arrow collider added for Lindholmen: %s" % child_name)

				elif scene_name.ends_with("johanneberg"):
					if MiniQuests.finished_quests.has("arrowJohanneberg"):
						if debug_enabled: print("[DEBUG] ArrowJohanneberg completed, freeing: %s" % child_name)
						child.queue_free()
					else:
						var area := add_Area3D_colision_to_mesh(child)
						area.connect("body_entered", Callable(self, "_on_arrow_body_entered").bind(area))
						area.collision_mask = GameState.PLAYER
						if debug_enabled: print("[DEBUG] Arrow collider added for Johanneberg: %s" % child_name)

				else:
					if debug_enabled: print("[DEBUG] Unknown scene context for arrow: %s in scene %s" % [child_name, scene_name])
			else:
				add_StaticBody3D_colision_to_mesh(child)  # Default: add collision
				if debug_enabled: print("[DEBUG] add collision")
				
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
			if debug_enabled: print("[DEBUG] Static collider created for: %s" % mesh_instance.name)
		else:
			if debug_enabled: print("[DEBUG] Failed to create static collider for: %s" % mesh_instance.name)

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
			if debug_enabled: print("[DEBUG] Area collider created for: %s" % mesh_instance.name)
		else:
			if debug_enabled: print("[DEBUG] Failed to create area collider for: %s" % mesh_instance.name)
	return area

func _on_arrow_body_entered(body: Node3D, arrow: Area3D):
	if body.is_in_group("player"):
		if debug_enabled: print("[DEBUG] Player entered arrow area: %s" % arrow.name)
		print("Welcome to Chalmers")
		GameState.add_score(1)
		var arrow_mesh = arrow.get_parent()

		for child in arrow_mesh.get_children():
			child.queue_free()

		await get_tree().create_timer(1.0).timeout
		arrow_mesh.queue_free()
		
		var scene_name := get_tree().current_scene.name.to_lower()

		if scene_name.ends_with("lindholmen"):
			MiniQuests.add_finished_quest("arrowLinholmen")
		elif scene_name.ends_with("johanneberg"):
			MiniQuests.add_finished_quest("arrowJohanneberg")
		else: print("[DEBUG] Unknown scene: ", scene_name)
	else:
		if debug_enabled: print("[DEBUG] Non-player entered arrow: %s (body: %s)" % [arrow.name, body.name])
