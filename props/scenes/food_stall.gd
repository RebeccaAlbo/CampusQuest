extends StaticBody3D

@onready var hover_text: Label3D = $HoverText

var player
var player_in_interact_zone: bool = false

# Makes hover_text visible when player is in close proximity
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_interact_zone = true
		hover_text.visible = true

# If interactions, add item to inventory and mark as picked up
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_in_interact_zone:
		var orders = MiniQuests.food_orders
		var order_count = orders.size()
		if order_count > 0:
			for food in orders:
				MiniQuests.add_item("food", food)
				MiniQuests.picked_up_items.append(food)
			MiniQuests.food_orders.clear()
			hover_text.text = "You have received your orders"
		else:
			hover_text.text = "You have no food orders"

# Makes hover_text invisible when player no longer is in close proximity
func _on_area_3d_body_exited(_body: Node3D) -> void:
	player_in_interact_zone = false
	hover_text.text = "Press F to interact"
	hover_text.visible = false
