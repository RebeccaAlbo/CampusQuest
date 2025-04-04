extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 15

var player
var player_in_chat_zone = false

func _ready():
	animation("Idle", 0.3)

func _on_chat_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_chat_zone = true
		animation("Waving", 0.3)


func _on_chat_detection_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_chat_zone = false
		animation("Idle", 0.3)
		
func animation(animation : String, time : float):
	animation_player.play(animation, time)
