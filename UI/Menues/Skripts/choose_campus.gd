extends Control


func _on_lindholmen_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Campus/campus_lindholmen.tscn")

func _on_johanneberg_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Campus/campus_johanneberg.tscn")

func _on_go_back_pressed() -> void:
	print("going back to: ", SceneManager.prev_scene_path)
	get_tree().change_scene_to_file(SceneManager.prev_scene_path)
