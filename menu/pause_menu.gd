extends Control

var _is_paused: bool = false:
	set = set_paused
	
	
func _unhandled_input(event: InputEvent) -> void:	
	if event.is_action_pressed("pause"):
		if _is_paused == false:
			_is_paused =  true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			_is_paused =  false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func set_paused(value:bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused

func _on_resume_pressed() -> void:
	_is_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_controls_pressed() -> void:
	SceneManager.prev_scene_path = "res://menu/pause_menu.tscn"
	get_tree().change_scene_to_file("res://menu/controls.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
