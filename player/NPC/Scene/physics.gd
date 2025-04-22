extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 15

var original_pos: Vector3

func _ready():
	animation("Idle", 0.3)
	
func face_toward(target_node: Node3D):
	original_pos = rotation
	var direction = (target_node.global_transform.origin - global_transform.origin)
	direction.y = 0  # Keep it level, no vertical tilt
	direction = direction.normalized()

	var target_rotation = Vector3(0, atan2(direction.x, direction.z), 0)
	rotation = target_rotation
	
func face_back():
		rotation = original_pos
		
func animation(anim : String, time : float):
	animation_player.play(anim, time)
	
func change_mark():
	print("changing mark")
	get_node("Check").visible = true
	get_node("Exlamation").visible = false
