extends Control

@onready var minimap: PanelContainer = $"../Minimap"
@onready var score: Label = $Score


var _is_paused: bool = false:
	set = set_paused

# Handles the "esc" key input to toggle the pause state, show/hide the minimap, 
# and control mouse visibility
func _unhandled_input(event: InputEvent) -> void:	
	if event.is_action_pressed("esc"):
		if _is_paused == false:
			_is_paused =  true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			_is_paused =  false
			get_tree().paused = _is_paused
			minimap.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Sets the paused state, hides the minimap, updates the game pause state, 
#and controls the visibility of the UI
func set_paused(value:bool) -> void:
	update_score_label()
	_is_paused = value
	minimap.visible = false
	get_tree().paused = _is_paused
	visible = _is_paused

# Resumes the game by unpausing the game state, showing the minimap, and capturing the mouse
func _on_resume_pressed() -> void:
	_is_paused = false
	get_tree().paused = _is_paused
	minimap.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Saves the game and quits the application
func _on_quit_game_pressed() -> void:
	GameState.save_game()
	get_tree().quit()

# Updates the score label with the current score value from the game state
func update_score_label():
	score.text = "Current score: %d" %GameState.score
