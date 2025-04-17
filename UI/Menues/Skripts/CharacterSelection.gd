extends Control

@onready var tester: CharacterBody3D = $"../../tester"
@onready var tester_j: CharacterBody3D = %testerJ



var hair_chosen: bool = false
var skin_chosen: bool = false
var shirt_chosen: bool = false


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print(tester_j)

func _unhandled_input(_event: InputEvent) -> void:
	if skin_chosen:
		if Input.is_action_just_pressed("left"):
			tester.change_skin_color(-1)
		elif Input.is_action_just_pressed("right"):
			tester.change_skin_color(1)
	elif hair_chosen:
		if Input.is_action_just_pressed("left"):
			tester.change_hair(-1)
		elif Input.is_action_just_pressed("right"):
			tester.change_hair(1)
	
func _on_hair_pressed() -> void:
	hair_chosen = true
	skin_chosen = false
	shirt_chosen = false

func _on_skin_pressed() -> void:
	hair_chosen = false
	skin_chosen = true
	shirt_chosen = false

func _on_shirt_pressed() -> void:
	hair_chosen = false
	skin_chosen = false
	shirt_chosen = true

func _on_continue_pressed() -> void:
	CharacterCust.skin_index = tester.current_skin_index
	CharacterCust.hair_index = tester.current_hair_index
	get_tree().change_scene_to_file("res://UI/Menues/Scenes/choose_campus.tscn")
	
