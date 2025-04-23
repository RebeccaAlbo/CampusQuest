extends Control

@onready var character: CharacterBody3D = $"../../BaseCharacter"

var hair_chosen: bool
var skin_chosen: bool
var shirt_chosen: bool
var pants_chosen: bool
var shoes_chosen: bool

func _ready() -> void:
	SceneManager.prev_scene_path = "res://UI/Menues/Scenes/main_menu.tscn"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hair_chosen = false
	skin_chosen = false
	shirt_chosen = false
	pants_chosen = false
	shoes_chosen = false
	
	character.can_move = false
	character.update_character(0, 0, 0, 0, 0)

func _unhandled_input(_event: InputEvent) -> void:
	# Changes character customization options based on which category is selected and input direction
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
	
	# Unpresses all buttons in the container except the Hair button
	for button in $VBoxContainer.get_children():
		if button != $VBoxContainer/Hair:
			button.call_deferred("set_pressed", false)

func _on_skin_pressed() -> void:
	hair_chosen = false
	skin_chosen = true
	shirt_chosen = false
	pants_chosen = false
	shoes_chosen = false
	
	# Unpresses all buttons in the container except the Skin button
	for button in $VBoxContainer.get_children():
		if button != $VBoxContainer/Skin:
			button.call_deferred("set_pressed", false)

func _on_shirt_pressed() -> void:
	hair_chosen = false
	skin_chosen = false
	shirt_chosen = true
	pants_chosen = false
	shoes_chosen = false
	
	# Unpresses all buttons in the container except the Shirt button
	for button in $VBoxContainer.get_children():
		if button != $VBoxContainer/Shirt:
			button.call_deferred("set_pressed", false)
	
func _on_pants_pressed() -> void:
	hair_chosen = false
	skin_chosen = false
	shirt_chosen = false
	pants_chosen = true
	shoes_chosen = false
	
	# Unpresses all buttons in the container except the Pants button
	for button in $VBoxContainer.get_children():
		if button != $VBoxContainer/Pants:
			button.call_deferred("set_pressed", false)

func _on_shoes_pressed() -> void:
	hair_chosen = false
	skin_chosen = false
	shirt_chosen = false
	pants_chosen = false
	shoes_chosen = true
	
	# Unpresses all buttons in the container except the Shoes button
	for button in $VBoxContainer.get_children():
		if button != $VBoxContainer/Shoes:
			button.call_deferred("set_pressed", false)

# Saves the current look of the character and switch scene
func _on_continue_pressed() -> void:
	CharacterCust.skin_index = character.current_skin_index
	CharacterCust.hair_index = character.current_hair_index
	CharacterCust.pant_index = character.current_pant_index
	CharacterCust.shirt_index = character.current_shirt_index
	CharacterCust.shoes_index = character.current_shoes_index
	
	SceneManager.prev_scene_path = "res://UI/Menues/Scenes/CharacterSelection.tscn"
	print(SceneManager.prev_scene_path)
	get_tree().change_scene_to_file("res://UI/Menues/Scenes/choose_campus.tscn")

func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file(SceneManager.prev_scene_path)
