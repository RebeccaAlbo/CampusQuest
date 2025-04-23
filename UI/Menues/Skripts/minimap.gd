extends PanelContainer

@onready var _minimap_camera: Camera3D = $SubViewportContainer/SubViewport/MinimapCamera
@onready var _base_character: CharacterBody3D = $"../../BaseCharacter"

# Camera follow character during gameplay
func _process(_delta : float) -> void:
	_minimap_camera.global_position = _base_character.global_position + Vector3.UP * 120
	
