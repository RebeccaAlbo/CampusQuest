extends Node3D

@onready var hover_text: Label3D = $HoverText


func _on_area_3d_mouse_entered() -> void:
	hover_text.visible = true

func _on_area_3d_mouse_exited() -> void:
	hover_text.visible = false
