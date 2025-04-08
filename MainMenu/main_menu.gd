extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()

func _on_start_pressed() -> void:
	print("Starting game")
	get_tree().change_scene_to_file("res://main.tscn")


func _on_exit_pressed() -> void:
	print("Exiting game")
	get_tree().quit()


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/controls.tscn")
