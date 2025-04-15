extends Control

@onready var _little_dude: CharacterBody3D = $"../../LittleDude"
@onready var _camera_3d: Camera3D = %Camera3D



func _process(_delta : float) -> void:
	_camera_3d.global_position = _little_dude.global_position + Vector3.UP * 10
