class_name Player
extends CharacterBody3D

# 3D movement parameters
var move_speed: float = 5.0
var touch_position: Vector2 = Vector2.ZERO
var is_touching: bool = false
var target_position: Vector3 = Vector3.ZERO

# Camera reference for screen-to-world conversion
@export var camera: Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_update_target_position(event.position)
			is_touching = true
		else:
			is_touching = false
	elif event is InputEventScreenDrag:
		_update_target_position(event.position)
		is_touching = true

func _update_target_position(screen_pos: Vector2) -> void:
	# Convert screen touch to 3D world position
	var ray_origin = camera.project_ray_origin(screen_pos)
	var ray_dir = camera.project_ray_normal(screen_pos)
	var ray_distance = camera.far  # Use camera's maximum render distance
	
	# Calculate intersection with ground plane (Y=0 in this example)
	var ground_plane = Plane(Vector3.UP, 0.0)
	target_position = ground_plane.intersects_ray(ray_origin, ray_dir * ray_distance)

func _physics_process(delta: float) -> void:
	if is_touching:
		# Calculate direction in XZ plane (ignore Y-axis for horizontal movement)
		var direction = (target_position - global_position).normalized()
		direction.y = 0  # Keep movement horizontal
		
		# Move character
		velocity = direction * move_speed
		move_and_slide()
		
		# Rotate character towards movement direction
		if direction.length() > 0.1:
			look_at(global_position + direction, Vector3.UP)
