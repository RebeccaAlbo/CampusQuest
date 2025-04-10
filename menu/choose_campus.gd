extends Control


func _on_lindholmen_pressed() -> void:
	print("Going to Lindholmen")
	get_tree().change_scene_to_file("res://campus_lindholmen.tscn")


func _on_johanneberg_pressed() -> void:
	print("Going to Johanneberg")
	get_tree().change_scene_to_file("res://campus_johanneberg.tscn")
