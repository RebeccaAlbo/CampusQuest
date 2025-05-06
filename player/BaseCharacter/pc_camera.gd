extends Camera3D

var follow_speed: float = 10.0

var target_pos: Vector3


func _ready() -> void:
	target_pos = position
	
func _process(delta: float) -> void:
	target_pos = get_parent().to_local(global_position)
	
	position = position.lerp(target_pos, follow_speed * delta)
