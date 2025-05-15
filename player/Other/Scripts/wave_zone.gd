extends Area3D

var player
var player_in_chat_zone = false
var npc

var interactButton: Button

func _ready():
	npc = get_parent()
	if GameState.is_mobile:
		interactButton = get_tree().current_scene.get_node("CanvasLayer").get_node("Interact")
		print("interact is: ", interactButton)
		

# Changes NPC animation to waving when player is in close proximity
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_chat_zone = true
		npc.animation("Waving", 0.3)
		if GameState.is_mobile:
			interactButton.visible =  true

# Changes NPC animation to idle when player is no longer in close proximity
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_chat_zone = false
		npc.animation("Idle", 0.3)
