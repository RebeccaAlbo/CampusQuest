extends Node3D

@onready var hover_text: Label3D = $HoverText

var player
var player_in_transport_zone: bool = false
var current_scene



func _on_area_3d_body_entered(body: Node3D) -> void:
	current_scene = get_tree().current_scene
	if body.is_in_group("player"):
		player = body
		player_in_transport_zone = true
		hover_text.visible = true


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_in_transport_zone:
		hover_text.visible = false
		if current_scene.name =="campus_johanneberg":
			get_tree().change_scene_to_file("res://campus_lindholmen.tscn")
		elif current_scene.name =="campus_lindholmen":
			get_tree().change_scene_to_file("res://campus_johanneberg.tscn")

func _on_area_3d_body_exited(_body: Node3D) -> void:
	hover_text.visible = false
