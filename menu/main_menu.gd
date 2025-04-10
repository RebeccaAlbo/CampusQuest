extends Control

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()

func _on_start_pressed() -> void:
	print("Starting game")
	get_tree().change_scene_to_file("res://menu/choose_campus.tscn")


func _on_exit_pressed() -> void:
	print("Exiting game")
	get_tree().quit()


func _on_controls_pressed() -> void:
	SceneManager.prev_scene_path = "res://menu/main_menu.tscn"
	get_tree().change_scene_to_file("res://menu/controls.tscn")
