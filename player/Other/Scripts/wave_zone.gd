extends Area3D

var player
var player_in_chat_zone = false
var npc

var interactButton: Button

func _ready():
	npc = get_parent()
	if GameState.is_mobile:
		interactButton = get_tree().current_scene.get_node("CanvasLayer").get_node("Interact")
		

# Changes NPC animation to waving when player is in close proximity
func _on_body_entered(body: Node3D) -> void:
	FlutterBridge.play_greeting(npc.name)
	if body.is_in_group("player"):
		if GameState.is_mobile:
			interactButton.modulate.a = 1.0
			interactButton.visible =  true
		player_in_chat_zone = true
		npc.animation("Waving", 0.3)

# Changes NPC animation to idle when player is no longer in close proximity
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if GameState.is_mobile:
			interactButton.modulate.a = 0.5
		player_in_chat_zone = false
		npc.animation("Idle", 0.3)
