extends Node3D

@export var override_depth_test: bool = false
@export var render_priority: int = 0
@export var material_color: Color = Color(0.2, 0.8, 0.2) # greenish

func _ready():
	apply_material_to_patches(self)

func apply_material_to_patches(node: Node):
	for child in node.get_children():
		if child is MeshInstance3D:
			var material := StandardMaterial3D.new()
			material.albedo_color = material_color
			material.render_priority = render_priority
			if override_depth_test:
				material.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_DISABLED
			child.material_override = material
		elif child.get_child_count() > 0:
			apply_material_to_patches(child)
