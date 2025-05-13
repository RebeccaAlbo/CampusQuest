extends Node

@onready var base_character: CharacterBody3D = $BaseCharacter
@onready var menu_button: Button = $CanvasLayer/MenuButton
@onready var minimap: PanelContainer = $CanvasLayer/Minimap
@onready var virtual_joystick: VirtualJoystick = $"CanvasLayer/Virtual Joystick"
@onready var creators: Node3D = $Creators
@onready var interact: Button = $CanvasLayer/Interact

@onready var svea: CharacterBody3D = $svea
@onready var kuggen: CharacterBody3D = $kuggen
@onready var jupiter: CharacterBody3D = $jupiter
@onready var saga: CharacterBody3D = $saga
@onready var patricia: CharacterBody3D = $patricia
@onready var aran: CharacterBody3D = $aran
@onready var anglia: CharacterBody3D = $anglia
@onready var book_box: StaticBody3D = $bookBox
@onready var food_stall: StaticBody3D = $foodStall
@onready var bug: StaticBody3D = $bug
@onready var key_kuggen: Node3D = $keyKuggen
@onready var wallet_math: Node3D = $walletMath



func _ready():
	if GameState.is_mobile:
		menu_button.visible = true
		minimap.visible = false
		interact.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		svea.scale = Vector3(5, 5, 5)
		kuggen.scale = Vector3(5, 5, 5)
		jupiter.scale = Vector3(5, 5, 5)
		saga.scale = Vector3(5, 5, 5)
		patricia.scale = Vector3(5, 5, 5)
		aran.scale = Vector3(5, 5, 5)
		anglia.scale = Vector3(5, 5, 5)
		base_character.scale = Vector3(5, 5, 5)
		creators.scale = Vector3(5, 5, 5)
		bug.scale = Vector3(5, 5, 5)
		book_box.scale = Vector3(3, 3, 3)
		food_stall.scale = Vector3(3, 3, 3)
		key_kuggen.scale = Vector3(5, 5, 5)
		wallet_math.scale = Vector3(5, 5, 5)
		
		
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		virtual_joystick.visible = false
	
	# Update saved states
	base_character.update_character(CharacterCust.skin_index, CharacterCust.hair_index, CharacterCust.pant_index, CharacterCust.shirt_index, CharacterCust.shoes_index)
	for npc_name in GameState.talked_to_npcs.keys():
		var npc = get_node_or_null(npc_name)
		if npc:
			npc.change_mark()
	
	if MiniQuests.bug_state["found"]:
		creators.visible = false
