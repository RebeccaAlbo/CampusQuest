extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var armature: Node3D = $Armature
@onready var spring_arm_pivot: Node3D = $SpringArmPivot
@onready var spring_arm: SpringArm3D = $SpringArmPivot/SpringArm3D
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var actionable_finder: Area3D = $Direction/ActionableFinder


const SPEED = 30.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = .15

var can_move: bool = true
var show_shoes: bool = true

var skin_colors = [
	Color(1.0, 0.8, 0.6),  # Light
	Color(0.8, 0.6, 0.4),  # Tan
	Color(0.5, 0.3, 0.2),  # Medium brown
	Color(0.3, 0.2, 0.1)   # Dark brown	
]

var hair_styles = [
	$Armature/Skeleton3D/Hair1,
	$Armature/Skeleton3D/Hair2,
	$Armature/Skeleton3D/Hair3,
	$Armature/Skeleton3D/Hair4,
]

var current_skin_index = 0
var current_hair_index = 0
var prev_hair = hair_styles[0]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_skin_color()
	add_to_group("player")
	
	if get_tree().current_scene.name == "CharacterSelection":
		can_move = false
	elif get_tree().current_scene.name == "campus_johanneberg" or get_tree().current_scene.name == "campus_lindholmen":
		update_character_skin(CharacterCust.skin_index)

func _unhandled_input(event: InputEvent) -> void:
	# Mouse control viewpoint
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * .001)
		spring_arm.rotate_x(-event.relative.y * .001)
		# No infinite rotation
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
		
	if Input.is_action_just_pressed("interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func _physics_process(delta: float) -> void:
	if !can_move:
		return
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# Mouse control direction of character
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		
	anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)

	move_and_slide()
	
func in_dialogue():
	velocity = Vector3.ZERO
	anim_tree.set("parameters/BlendSpace1D/blend_position", 0.0)
	can_move = false
	
func end_dialoque():
	can_move = true
	
func change_skin_color(direction: int):
	current_skin_index = (current_skin_index + direction) % skin_colors.size()
	if current_skin_index < 0:
		current_skin_index = skin_colors.size() - 1
	update_skin_color()

func update_skin_color():
	var skin = $Armature/Skeleton3D/Body
	if skin == null:
		print("skin not found")
		return
		
	var material = skin.get_surface_override_material(0)
	
	if material == null:
		material = skin.get_active_material(0).duplicate()
		skin.set_surface_override_material(0, material)

	material.albedo_color = skin_colors[current_skin_index]

func change_hair(direction: int):
	current_hair_index = (current_hair_index + direction) % hair_styles.size()
	if current_hair_index < 0:
		current_hair_index = hair_styles.size() - 1
	update_hair_style()
		
func update_hair_style():
	prev_hair.visible = false
	var current_hair = hair_styles[current_hair_index]
	current_hair.visible = true
		
func update_character_skin(index: int):
	var skin = $Armature/Skeleton3D/Body
	var material = skin.get_surface_override_material(0)
	material.albedo_color = skin_colors[index]
	
	
	
