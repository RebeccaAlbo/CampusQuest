extends Area3D

@export var dialoque_resource : DialogueResource
@export var dialoque_start : String = ""

signal dialogue_starting
signal dialogue_ending

const Balloon = preload("res://dialogue/balloon.tscn")
# For zooming in on NPC during conversation
var camera: Camera3D = null
var phone_camera: Camera3D = null
var dialogue_camera: Camera3D = null
var interactButton: Button = null
var minimap


var player
var npc
var department: String

func _ready():
	minimap = get_tree().current_scene.get_node("CanvasLayer/Minimap")
	npc = get_parent()
	if npc:
		department = npc.name
		if dialoque_start == "":
			dialoque_start = department
		

func action() -> void:
	interactButton = get_tree().current_scene.get_node("CanvasLayer").get_node("Interact")
	
	#Find the camera
	if camera == null:
		player = get_tree().get_first_node_in_group("player")
		if player:
			var node3d = player.get_node_or_null("SpringArmPivot")
			var neck = player.get_node_or_null("Neck")
			phone_camera = player.get_node_or_null("PhoneCamera")
			if node3d and neck:
				dialogue_camera = neck.get_node_or_null("DialogueCamera")
				var spring_arm = node3d.get_node_or_null("SpringArm3D")
				if spring_arm:
					camera = spring_arm.get_node_or_null("PCCamera")  # Finally, get Camera3D
	
	# If the camera exists, store original position and smoothly zoom it toward the NPC
	if camera and dialogue_camera and phone_camera and interactButton:
		camera.current = false
		phone_camera.current = false
		dialogue_camera.current = true
		interactButton.visible = false
	else:
		print("not all cameras found")
	
	# Set up for dialoque environment
	minimap.visible = false
	player.in_dialogue(npc)
	npc.face_toward(player)
	# needed to avoid npc to keep waving instead of talking during dialogue
	await get_tree().create_timer(0.1).timeout
	npc.animation("Talking", 0.3)
	
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	GameState.set_mouse_state(GameState.MouseState.UI)
	balloon.start(dialoque_resource, dialoque_start)
	
	# Wait for end of dialogue, then reset everything
	await DialogueManager.dialogue_ended
	if (FlutterBridge.running_extra_info):
		await FlutterBridge.extra_info_ended
	minimap.visible = true
	player.end_dialoque()
	npc.animation("Idle", 0.3)
	npc.face_back()
	dialogue_camera.current = false
	if GameState.is_mobile:
		phone_camera.current = true
		interactButton.visible = true
	else:
		camera.current = true
	GameState.set_mouse_state(GameState.MouseState.GAMEPLAY)
