extends Area3D

var player
var player_in_chat_zone = false
var npc

func _ready():
	npc = get_parent()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_chat_zone = true
		npc.animation("Waving", 0.3)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_chat_zone = false
		npc.animation("Idle", 0.3)
