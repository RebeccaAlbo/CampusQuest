extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 15


func _ready():
	animation("Idle", 0.3)
		
func animation(animation : String, time : float):
	animation_player.play(animation, time)
