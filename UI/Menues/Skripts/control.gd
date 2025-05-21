extends Control

@onready var pause_menu: Control = $"."
@onready var pc: ColorRect = $Panel/PC
@onready var mobile: ColorRect = $Panel/Mobile


func _ready() -> void:
	if GameState.is_mobile:
		mobile.visible = true
	else:
		pc.visible = true

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file(SceneManager.prev_scene_path)

func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file(SceneManager.prev_scene_path)
