extends Control

@onready var pause_menu: Control = $"../PauseMenu"
@onready var minimap: PanelContainer = $"../Minimap"

# Paused by other menues
var paused: bool = false
# Paused by self
var _is_paused: bool = false:
	set = set_paused

# Handles user input to toggle pause state and control minimap visibility
func _unhandled_input(event: InputEvent) -> void:	
	if paused:
		return
	
	if event.is_action_pressed("map"):
		if _is_paused == false:
			_is_paused =  true
			pause_menu.paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			_is_paused =  false
			get_tree().paused = _is_paused
			minimap.visible = true
			pause_menu.paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Sets the paused state, hides the minimap, and updates the game pause state accordingly
func set_paused(value:bool) -> void:
	_is_paused = value
	minimap.visible = false
	get_tree().paused = _is_paused
	visible = _is_paused
