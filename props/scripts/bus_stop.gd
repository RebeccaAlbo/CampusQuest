extends Node3D

@onready var hover_text: Label3D = $HoverText

var interactButton
var player
var player_in_transport_zone: bool = false
var current_scene

func _ready() -> void:
	interactButton = get_tree().current_scene.get_node("CanvasLayer").get_node("Interact")

# Makes hover_text visible when player is in close proximity
func _on_area_3d_body_entered(body: Node3D) -> void:
	current_scene = get_tree().current_scene
	if body.is_in_group("player"):
		interactButton.modulate.a = 1.0
		player = body
		player_in_transport_zone = true
		if !GameState.is_mobile:
			hover_text.visible = true

# Changes scene when player chooses
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		travel()

# Makes hover_text invisible when player no longer is in close proximity
func _on_area_3d_body_exited(_body: Node3D) -> void:
	interactButton.modulate.a = 0.5
	player_in_transport_zone = false
	hover_text.visible = false
	
func travel():
	if player_in_transport_zone:
		hover_text.visible = false
		if current_scene.name =="campus_johanneberg":
			get_tree().change_scene_to_file("res://UI/Campus/campus_lindholmen.tscn")
		elif current_scene.name =="campus_lindholmen":
			get_tree().change_scene_to_file("res://UI/Campus/campus_johanneberg.tscn")

func _on_interact_pressed() -> void:
	travel()
