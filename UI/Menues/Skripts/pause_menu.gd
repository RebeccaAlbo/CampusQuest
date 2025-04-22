extends Control

@onready var minimap: PanelContainer = $"../Minimap"
@onready var score: Label = $Score


var _is_paused: bool = false:
	set = set_paused
	
func _unhandled_input(event: InputEvent) -> void:	
	if event.is_action_pressed("menu"):
		if _is_paused == false:
			_is_paused =  true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			_is_paused =  false
			get_tree().paused = _is_paused
			minimap.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func set_paused(value:bool) -> void:
	update_score_label()
	_is_paused = value
	minimap.visible = false
	get_tree().paused = _is_paused
	visible = _is_paused

func _on_resume_pressed() -> void:
	_is_paused = false
	get_tree().paused = _is_paused
	minimap.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_game_pressed() -> void:
	GameState.save_game()
	get_tree().quit()
	
func update_score_label():
	score.text = "Current score: %d" %GameState.score
