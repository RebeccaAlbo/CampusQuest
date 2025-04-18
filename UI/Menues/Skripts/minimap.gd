extends PanelContainer

@onready var _camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var _base_character: CharacterBody3D = $"../../BaseCharacter"



func _process(_delta : float) -> void:
	_camera_3d.global_position = _base_character.global_position + Vector3.UP * 120
	
