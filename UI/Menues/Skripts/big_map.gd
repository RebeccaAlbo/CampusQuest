extends Control

@onready var minimap: PanelContainer = $"../Minimap"

var _is_paused: bool = false:
	set = set_paused
	
	
func _unhandled_input(event: InputEvent) -> void:	
	if event.is_action_pressed("map"):
		if _is_paused == false:
			_is_paused =  true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			_is_paused =  false
			get_tree().paused = _is_paused
			minimap.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func set_paused(value:bool) -> void:
	_is_paused = value
	minimap.visible = false
	get_tree().paused = _is_paused
	visible = _is_paused
