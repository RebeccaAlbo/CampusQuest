extends Control


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menues/Scenes/CharacterSelection.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_controls_pressed() -> void:
	SceneManager.prev_scene_path = "res://UI/Menues/Scenes/main_menu.tscn"
	get_tree().change_scene_to_file("res://UI/Menues/Scenes/controls.tscn")


func _on_contiue_pressed() -> void:
	GameState.load_game()
	get_tree().change_scene_to_file("res://UI/Menues/Scenes/choose_campus.tscn")
