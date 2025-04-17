extends Node3D

@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var hover_text: Label3D = $HoverText

var mouse_over := false



func _on_area_3d_mouse_entered() -> void:
	hover_text.visible = true


func _on_area_3d_mouse_exited() -> void:
	hover_text.visible = false
