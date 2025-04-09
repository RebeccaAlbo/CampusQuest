extends Control

	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
