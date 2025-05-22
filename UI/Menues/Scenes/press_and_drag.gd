extends Node3D

@onready var animation_player: AnimationPlayer = $Sprite3D/AnimationPlayer
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var label_3d: Label3D = $Label3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.is_mobile and !GameState.is_informed_press_and_drag:
		label_3d.visible = true
		sprite_3d.visible = true
		animation_player.play("move")
		
func remove_from_screen():
	sprite_3d.visible = false
	animation_player.stop()
	label_3d.visible = false
	GameState.is_informed_press_and_drag = true
