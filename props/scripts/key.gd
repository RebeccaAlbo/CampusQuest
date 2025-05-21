extends Node3D

@onready var hover_text: Label3D = $HoverText

var interactButton
var node_name := "key"
var player
var player_in_pickup_zone: bool = false

func _ready() -> void:
	interactButton = get_tree().current_scene.get_node("CanvasLayer").get_node("Interact")
	# Check if item has already been picked up
	if self.name in MiniQuests.picked_up_items:
		self.visible = false

# Makes hover_text visible when player is in close proximity
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		interactButton.modulate.a = 1.0
		player = body
		player_in_pickup_zone = true
		if !GameState.is_mobile:
			hover_text.visible = true

# If interaction, add item to inventory and mark as picked up
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		pick_up()

# Makes hover_text invisible when player no longer is in close proximity
func _on_area_3d_body_exited(_body: Node3D) -> void:
	interactButton.modulate.a = 0.5
	player_in_pickup_zone = false
	hover_text.visible = false

func pick_up():
	if player_in_pickup_zone:
		hover_text.visible = false
		self.visible = false
		MiniQuests.add_item(node_name)
		MiniQuests.picked_up_items.append(self.name)

func _on_interact_pressed() -> void:
	pick_up()
