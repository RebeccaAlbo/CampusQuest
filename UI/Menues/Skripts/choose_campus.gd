extends Control

@onready var lindholmen: Button = $Panel/HBoxContainer/lindholmen
@onready var johanneberg: Button = $Panel/HBoxContainer/johanneberg
@onready var h_box_container: HBoxContainer = $Panel/HBoxContainer
@onready var chose: Label = $Panel/Chose


func _on_lindholmen_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Campus/campus_lindholmen.tscn")

func _on_johanneberg_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Campus/campus_johanneberg.tscn")

func _on_go_back_pressed() -> void:
	print("going back to: ", SceneManager.prev_scene_path)
	get_tree().change_scene_to_file(SceneManager.prev_scene_path)
	
