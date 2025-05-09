extends Node

@onready var base_character: CharacterBody3D = $BaseCharacter
@onready var menu_button: Button = $CanvasLayer/MenuButton
@onready var minimap: PanelContainer = $CanvasLayer/Minimap
@onready var virtual_joystick: VirtualJoystick = $"CanvasLayer/Virtual Joystick"


func _ready():
	if GameState.is_mobile:
		menu_button.visible = true
		minimap.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		virtual_joystick.visible = false
	
	# Update saved states
	base_character.update_character(CharacterCust.skin_index, CharacterCust.hair_index, CharacterCust.pant_index, CharacterCust.shirt_index, CharacterCust.shoes_index)
	for npc_name in GameState.talked_to_npcs.keys():
		var npc = get_node_or_null(npc_name)
		if npc:
			npc.change_mark()
