extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 15

var original_pos: Vector3

func _ready():
	animation("Idle", 0.3)

# Rotates the object to face toward the target node, keeping the rotation level on the horizontal axis
func face_toward(target_node: Node3D):
	original_pos = rotation
	var direction = (target_node.global_transform.origin - global_transform.origin)
	direction.y = 0  # Keep it level, no vertical tilt
	direction = direction.normalized()

	var target_rotation = Vector3(0, atan2(direction.x, direction.z), 0)
	rotation = target_rotation

# Return to original position after ended dialogue
func face_back():
		rotation = original_pos

# Changes the current animation of the NPC
func animation(anim : String, time : float):
	animation_player.play(anim, time)

# Updates which Sprite3D is visible above NPC on maps
func change_mark():
	get_node("Check").visible = true
	get_node("Exlamation").visible = false
