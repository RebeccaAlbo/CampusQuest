extends Control

@onready var tester: CharacterBody3D = $"../../tester"


var hair_chosen: bool = false
var skin_chosen: bool = false
var shirt_chosen: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready to customize character")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unhandled_input(event: InputEvent) -> void:
	if skin_chosen == true:
		if Input.is_action_just_pressed("left"):
			print("skin color -1")
			tester.change_skin_color(-1)
		elif Input.is_action_just_pressed("right"):
			tester.change_skin_color(1)
			print("skin color 1")
	
	
func _on_hair_pressed() -> void:
	print("hair chosen")
	hair_chosen = true
	skin_chosen = false
	shirt_chosen = false

func _on_skin_pressed() -> void:
	print("skin chosen")
	hair_chosen = false
	skin_chosen = true
	shirt_chosen = false

func _on_shirt_pressed() -> void:
	print("shirt chosen")
	hair_chosen = false
	skin_chosen = false
	shirt_chosen = true
