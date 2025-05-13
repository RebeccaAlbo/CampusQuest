extends Node3D

@onready var hover_text: Label3D = $HoverText

var node_name := ""
var player
var player_in_pickup_zone: bool = false

func _ready() -> void:
	# Check if item has already been picked up
	if MiniQuests.bug_quest_given:
		self.visible = true

# Makes hover_text visible when player is in close proximity
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_pickup_zone = true
		hover_text.visible = true

# If interactions, add item to inventory and mark as picked up
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_in_pickup_zone:
		hover_text.visible = false
		self.visible = false
		MiniQuests.bug_found = true

# Makes hover_text invisible when player no longer is in close proximity
func _on_area_3d_body_exited(_body: Node3D) -> void:
	player_in_pickup_zone = false
	hover_text.visible = false
