extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var armature: Node3D = $Armature
@onready var spring_arm_pivot: Node3D = $SpringArmPivot
@onready var spring_arm: SpringArm3D = $SpringArmPivot/SpringArm3D
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var actionable_finder: Area3D = $Direction/ActionableFinder


const SPEED = 30.0
const LERP_VAL = .15

var can_move: bool = true

var skin_colors = [
	Color(0.98, 0.9, 0.78),   # Very light cream 
	Color(0.95, 0.82, 0.65),  # Light 
	Color(0.75, 0.6, 0.45),   # Tan 
	Color(0.45, 0.35, 0.25),  # Medium brown 
	Color(0.28, 0.2, 0.12)    # Dark brown 
]
var hair_styles = [
	$Armature/Skeleton3D/Hair1,
	$Armature/Skeleton3D/Hair2,
	$Armature/Skeleton3D/Hair3,
	$Armature/Skeleton3D/Hair4,
	$Armature/Skeleton3D/Hair5,
	$Armature/Skeleton3D/Hair6
]
var pant_colors = [
	Color(0.05, 0.05, 0.05),     # Black
	Color(0.6, 0.8, 1.0),        # Light Blue
	Color(0.1, 0.2, 0.4),        # Dark Blue
	Color(0.9, 0.85, 0.7),       # Light Beige
	Color(0.6, 0.5, 0.35)        # Dark Beige
]
var shirt_colors = [
	Color(0.95, 0.95, 0.95),     # Off-White / Light Gray-White
	Color(0.05, 0.05, 0.05),     # Black
	Color(0.7, 0.5, 0.1),        # Muted Orange
	Color(0.5, 0.0, 0.0),        # Dark Red
	Color(0.15, 0.3, 0.15),      # Muted Green
	Color(0.1, 0.2, 0.4),        # Desaturated Blue
	Color(0.5, 0.3, 0.4),        # Dusty Pink
	Color(0.7, 0.6, 0.1)         # Warm Muted Yellow
]
var shoes_colors = [
	Color(0.95, 0.95, 0.95),     # Off-White / Light Gray-White
	Color(0.05, 0.05, 0.05),     # Black
	Color(0.4, 0.3, 0.2),        # Dark Brown
	Color(0.7, 0.55, 0.4),       # Light Brown / Tan
	Color(0.2, 0.3, 0.5)         # Muted Navy Blue
]

var current_skin_index = 0
var current_hair_index = 0
var current_pant_index = 0
var current_shirt_index = 0
var current_shoes_index = 0
var prev_hair

func _ready():
	add_to_group("player")
	prev_hair = hair_styles[current_hair_index]

func _unhandled_input(event: InputEvent) -> void:
	# Mouse control viewpoint
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * .001)
		spring_arm.rotate_x(-event.relative.y * .001)
		# No infinite rotation
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
	
	# Trigger the action of the first overlapping actionable object
	if Input.is_action_just_pressed("interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func _physics_process(delta: float) -> void:
	if !can_move:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
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

# Stops player movement, resets animation blend, and disables movement during dialogue	
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
	prev_hair = current_hair

func change_pant_color(direction: int):
	current_pant_index = (current_pant_index + direction) % pant_colors.size()
	if current_pant_index < 0:
		current_pant_index = pant_colors.size() - 1
	update_pant_color()

func update_pant_color():
	var pant = $Armature/Skeleton3D/Pants1
	var material = pant.get_surface_override_material(0)
	if material == null:
		material = pant.get_active_material(0).duplicate()
		pant.set_surface_override_material(0, material)
	material.albedo_color = pant_colors[current_pant_index]

func change_shirt_color(direction: int):
	current_shirt_index = (current_shirt_index + direction) % shirt_colors.size()
	if current_shirt_index < 0:
		current_shirt_index = shirt_colors.size() - 1
	update_shirt_color()	
	
func update_shirt_color():
	var shirt = $Armature/Skeleton3D/Shirt
	var material = shirt.get_surface_override_material(0)
	if material == null:
		material = shirt.get_active_material(0).duplicate()
		shirt.set_surface_override_material(0, material)
	material.albedo_color = shirt_colors[current_shirt_index]
	
func change_shoes_color(direction: int):
	current_shoes_index = (current_shoes_index + direction) % shoes_colors.size()
	if current_shoes_index < 0:
		current_shoes_index = shoes_colors.size() - 1
	update_shoes_color()

func update_shoes_color():
	var shoes = $Armature/Skeleton3D/Shoe
	var material = shoes.get_surface_override_material(0)
	if material == null:
		material = shoes.get_active_material(0).duplicate()
		shoes.set_surface_override_material(0, material)
	material.albedo_color = shoes_colors[current_shoes_index]

# Update the look of the character
func update_character(skin_index: int, hair_index: int, pant_index: int, shirt_index: int, shoes_index: int):
	
	#Set correct skin color
	var skin = $Armature/Skeleton3D/Body
	var skin_material = skin.get_surface_override_material(0)
	if skin_material == null:
		var base_mat = skin.get_active_material(0)
		if base_mat != null:
			skin_material = base_mat.duplicate()
			skin.set_surface_override_material(0, skin_material)
	if skin_material != null:
		skin_material.albedo_color = skin_colors[skin_index]
	
	#Set correct hair style
	for hair in hair_styles:
		hair.visible = false
	var current_hair = hair_styles[hair_index]
	current_hair.visible = true
	
	#Set correct pant color
	var pants = $Armature/Skeleton3D/Pants1
	var pants_material = pants.get_surface_override_material(0)
	if pants_material == null:
		var active_material = pants.get_active_material(0)
		if active_material != null:
			pants_material = active_material.duplicate()
			pants.set_surface_override_material(0, pants_material)
	if pants_material != null:
		pants_material.albedo_color = pant_colors[pant_index]
	
	#Set correct shirt color
	var shirt = $Armature/Skeleton3D/Shirt
	var shirt_material = shirt.get_surface_override_material(0)
	if shirt_material == null:
		var active_material = shirt.get_active_material(0)
		if active_material != null:
			shirt_material = active_material.duplicate()
			shirt.set_surface_override_material(0, shirt_material)
	if shirt_material != null:
		shirt_material.albedo_color = shirt_colors[shirt_index]
	
	#Set correct shoes color
	var shoes = $Armature/Skeleton3D/Shoe
	var shoes_material = shoes.get_surface_override_material(0)
	if shoes_material == null:
		var active_material = shoes.get_active_material(0)
		if active_material != null:
			shoes_material = active_material.duplicate()
			shoes.set_surface_override_material(0, shoes_material)
	if shoes_material != null:
		shoes_material.albedo_color = shoes_colors[shoes_index]	
	
