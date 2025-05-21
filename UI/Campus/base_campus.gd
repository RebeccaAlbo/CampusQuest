extends Node
class_name Campus

@onready var base_character: CharacterBody3D = $BaseCharacter
@onready var menu_button: Button = $CanvasLayer/MenuButton
@onready var minimap: PanelContainer = $CanvasLayer/Minimap
@onready var interact: Button = $CanvasLayer/Interact

func _ready():
	if GameState.is_mobile:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		set_mobile_UI()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		set_web_UI()
		
	# Update saved states
	base_character.update_character(CharacterCust.skin_index, CharacterCust.hair_index, CharacterCust.pant_index, CharacterCust.shirt_index, CharacterCust.shoes_index)
	for npc_name in GameState.talked_to_npcs.keys():
		var npc = get_node_or_null(npc_name)
		if npc:
			npc.change_mark()
			
func set_mobile_UI() :
	menu_button.visible = true
	menu_button.visible = true
	minimap.visible = false
	interact.visible = true
func set_web_UI():
	menu_button.visible = false
	menu_button.visible = false
	minimap.visible = true
	interact.visible = false
func _on_interact_pressed() -> void:
	pass # Replace with function body.
