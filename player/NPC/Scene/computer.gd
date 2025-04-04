extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 15


func _ready():
	animation("Idle", 0.3)
	
func face_toward(target_node: Node3D):
	var direction = (target_node.global_transform.origin - global_transform.origin)
	direction.y = 0  # Keep it level, no vertical tilt
	direction = direction.normalized()

	var target_rotation = Vector3(0, atan2(direction.x, direction.z), 0)
	rotation = target_rotation
		
func animation(animation : String, time : float):
	animation_player.play(animation, time)
