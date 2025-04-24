extends Control

@onready var lindholmen: Button = $Panel/HBoxContainer/lindholmen
@onready var johanneberg: Button = $Panel/HBoxContainer/johanneberg
@onready var h_box_container: HBoxContainer = $Panel/HBoxContainer
@onready var chose: Label = $Chose

var temp: bool = false

func _ready() -> void:
	if GameState.is_mobile and temp:
		phone_layout()

func _on_lindholmen_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Campus/campus_lindholmen.tscn")

func _on_johanneberg_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Campus/campus_johanneberg.tscn")

func _on_go_back_pressed() -> void:
	print("going back to: ", SceneManager.prev_scene_path)
	get_tree().change_scene_to_file(SceneManager.prev_scene_path)
	
func phone_layout(): 
	lindholmen.add_theme_font_size_override("font_size", 36)
	johanneberg.add_theme_font_size_override("font_size", 36)
	h_box_container.size.y = 120
	h_box_container.position.x = 180
	chose.add_theme_font_size_override("font_size", 40)
	chose.position.y = 170
