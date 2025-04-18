extends Control

@onready var character: CharacterBody3D = $"../../BaseCharacter"


var hair_chosen: bool
var skin_chosen: bool
var shirt_chosen: bool
var pants_chosen: bool
var shoes_chosen: bool

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hair_chosen = false
	skin_chosen = false
	shirt_chosen = false
	pants_chosen = false
	shoes_chosen = false

func _unhandled_input(_event: InputEvent) -> void:
	if skin_chosen:
		if Input.is_action_just_pressed("left"):
			character.change_skin_color(-1)
		elif Input.is_action_just_pressed("right"):
			character.change_skin_color(1)
	elif hair_chosen:
		if Input.is_action_just_pressed("left"):
			character.change_hair(-1)
		elif Input.is_action_just_pressed("right"):
			character.change_hair(1)
	elif pants_chosen:
		if Input.is_action_just_pressed("left"):
			character.change_pant_color(-1)
		elif Input.is_action_just_pressed("right"):
			character.change_pant_color(1)
	elif shirt_chosen:
		if Input.is_action_just_pressed("left"):
			character.change_shirt_color(-1)
		elif Input.is_action_just_pressed("right"):
			character.change_shirt_color(1)
	elif shoes_chosen:
		if Input.is_action_just_pressed("left"):
			character.change_shoes_color(-1)
		elif Input.is_action_just_pressed("right"):
			character.change_shoes_color(1)
	
func _on_hair_pressed() -> void:
	hair_chosen = true
	skin_chosen = false
	shirt_chosen = false
	pants_chosen = false
	shoes_chosen = false

func _on_skin_pressed() -> void:
	hair_chosen = false
	skin_chosen = true
	shirt_chosen = false
	pants_chosen = false
	shoes_chosen = false

func _on_shirt_pressed() -> void:
	hair_chosen = false
	skin_chosen = false
	shirt_chosen = true
	pants_chosen = false
	shoes_chosen = false
	
func _on_pants_pressed() -> void:
	hair_chosen = false
	skin_chosen = false
	shirt_chosen = false
	pants_chosen = true
	shoes_chosen = false

func _on_shoes_pressed() -> void:
	print("shoes pressed")
	hair_chosen = false
	skin_chosen = false
	shirt_chosen = false
	pants_chosen = false
	shoes_chosen = true

func _on_continue_pressed() -> void:
	CharacterCust.skin_index = character.current_skin_index
	CharacterCust.hair_index = character.current_hair_index
	CharacterCust.pant_index = character.current_pant_index
	CharacterCust.shirt_index = character.current_shirt_index
	CharacterCust.shoes_index = character.current_shoes_index
	
	get_tree().change_scene_to_file("res://UI/Menues/Scenes/choose_campus.tscn")
	
