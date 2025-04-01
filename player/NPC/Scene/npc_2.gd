extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 15

var player
var player_in_chat_zone = false

func _on_chat_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_chat_zone = true
		print("player has entered")
		animation_player.play("Waving", 0.3)


func _on_chat_detection_area_body_exited(body: Node3D) -> void:
	print("Body exited: " + str(body))
	if body.is_in_group("player"):
		player_in_chat_zone = false
		print("player has exited")
		animation_player.play("Idle", 0.3)
