extends Control

@onready var controls: Button = $Panel/VBoxContainer/Controls
@onready var contiue: Button = $Panel/VBoxContainer/Contiue
@onready var settings: Button = $Panel/VBoxContainer/Settings


func _ready() -> void:
	SceneManager.prev_scene_path = "res://UI/Menues/Scenes/main_menu.tscn"
	if GameState.is_mobile:
		controls.visible = false
	var success := await GameState.load_game()
	if (success):
		contiue.visible = true
	else:
		contiue.visible = false
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()

func _on_start_pressed() -> void:
	GameState.new_game()
	get_tree().change_scene_to_file("res://UI/Menues/Scenes/CharacterSelection.tscn")


func _on_exit_pressed() -> void:
	GameState.quit_game()


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menues/Scenes/controls.tscn")


func _on_contiue_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menues/Scenes/choose_campus.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menues/Scenes/settings_menu.tscn")
