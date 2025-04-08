extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
