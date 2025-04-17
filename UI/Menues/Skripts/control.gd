extends Control

@onready var pause_menu: Control = $"."

func _ready() -> void:
	print("Controls scene ready")
	var exit_button = $exit
	if exit_button:
		print("button found")
		exit_button.pressed.connect(_on_exit_pressed)
	else:
		print("no button")
	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://UI/Menues/Scenes/main_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file(SceneManager.prev_scene_path)
