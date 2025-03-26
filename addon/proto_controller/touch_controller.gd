extends CharacterBody3D
class_name Player

# Movement parameters
@export var move_speed: float = 5.0
@export var touch_deadzone: float = 50.0  # Minimum touch movement to register
@export var camera: Camera3D  # Assign in inspector

var input_vector: Vector2 = Vector2.ZERO
var is_touching: bool = false
var touch_start_pos: Vector2 = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start_pos = event.position
			is_touching = true
		else:
			is_touching = false
			input_vector = Vector2.ZERO
			
	elif event is InputEventScreenDrag:
		_update_input_vector(event.position)

func _update_input_vector(screen_pos: Vector2) -> void:
	var touch_offset = screen_pos - touch_start_pos
	
	# Apply deadzone
	if touch_offset.length() > touch_deadzone:
		input_vector = touch_offset.normalized()
	else:
		input_vector = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Handle gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	if is_touching:
		# Get camera basis vectors
		var camera_forward = -camera.global_transform.basis.z.normalized()
		var camera_right = camera.global_transform.basis.x.normalized()
		
		# Create camera-relative movement vector
		var move_dir = (camera_right * input_vector.x) + (camera_forward * input_vector.y)
		move_dir = move_dir.normalized()
		
		# Apply movement to horizontal plane only
		velocity.x = move_dir.x * move_speed
		velocity.z = move_dir.z * move_speed
	else:
		# Gradually stop horizontal movement
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
	
	move_and_slide()
