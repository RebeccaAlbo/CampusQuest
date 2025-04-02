extends Area3D

@export var dialoque_resrouce : DialogueResource
@export var dialoque_start : String = "start"

const Balloon = preload("res://Dialogue/balloon.tscn")
# For zooming in on NPC during conversation
var camera: Camera3D = null
var spring_arm: SpringArm3D
var original_camera_position: Vector3
var zoom_offset: Vector3 = Vector3(0, 1, 1)  # Adjust zoom position
var initial_camera_pos: Vector3
var original_spring_arm_length: float

func action() -> void:
	var npc = get_parent()
	npc.animation("Talking", 0.3)
	
	#Find the camera
	if camera == null:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			var node3d = player.get_node_or_null("SpringArmPivot")
			if node3d:
				spring_arm = node3d.get_node_or_null("SpringArm3D")
				if spring_arm:
					camera = spring_arm.get_node_or_null("Camera3D")  # Finally, get Camera3D

	if camera:
		print("camera found: ", camera.name)
		original_camera_position = camera.global_transform.origin
		var target_position = npc.global_transform.origin + zoom_offset
		smooth_camera_zoom(target_position)
	
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialoque_resrouce, dialoque_start)
	
	
	await DialogueManager.dialogue_ended
	reset_camera_position()


func smooth_camera_zoom(target_pos: Vector3) -> void:
	if camera:
		if !initial_camera_pos:
			initial_camera_pos = spring_arm.global_transform.origin # Save initial position if not already set
		original_spring_arm_length = spring_arm.spring_length
		# zoom-in
		spring_arm.spring_length = 5.0
		var tween = get_tree().create_tween()
		tween.tween_property(spring_arm, "global_transform:origin", target_pos, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func reset_camera_position() -> void:
		spring_arm.spring_length = original_spring_arm_length
		if camera:
			var tween = get_tree().create_tween()
			tween.tween_property(spring_arm, "global_transform:origin", initial_camera_pos, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
