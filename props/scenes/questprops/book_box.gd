extends StaticBody3D

@onready var hover_text: Label3D = $HoverText

var player
var player_in_interact_zone: bool = false

# Makes hover_text visible when player is in close proximity
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_interact_zone = true
		if !GameState.is_mobile:
			hover_text.visible = true

# If interactions, add item to inventory and mark as picked up
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and player_in_interact_zone:
		var count = MiniQuests.get_item_count("book")
		hover_text.visible = true
		if count > 0:
			if count > 1:
				hover_text.text = "Books returned"
			else:
				hover_text.text = "Book returned"
			
			#MiniQuests.remove_item("book")
			GameState.add_score(count)
			MiniQuests.add_finished_quest("book")
		else:
			hover_text.text = "You have no book to return"

# Makes hover_text invisible when player no longer is in close proximity
func _on_area_3d_body_exited(_body: Node3D) -> void:
	player_in_interact_zone = false
	hover_text.visible = false
	hover_text.text = "Press F to interact"
