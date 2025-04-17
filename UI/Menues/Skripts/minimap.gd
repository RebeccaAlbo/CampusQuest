extends PanelContainer

@onready var _camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var little_dude: CharacterBody3D = $"../../LittleDude"


func _process(_delta : float) -> void:
	_camera_3d.global_position = little_dude.global_position + Vector3.UP * 120
	
