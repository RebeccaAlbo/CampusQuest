extends Node

@onready var base_character: CharacterBody3D = $BaseCharacter
@onready var menu_button: Button = $CanvasLayer/MenuButton
@onready var minimap: PanelContainer = $CanvasLayer/Minimap


func _ready():
	if GameState.is_mobile:
		menu_button.visible = true
		minimap.visible = false
		
	# Update saved states
	base_character.update_character(CharacterCust.skin_index, CharacterCust.hair_index, CharacterCust.pant_index, CharacterCust.shirt_index, CharacterCust.shoes_index)
	for npc_name in GameState.talked_to_npcs.keys():
		var npc = get_node_or_null(npc_name)
		if npc:
			npc.change_mark()
			
	# Disable mouse during gameplay
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Get the reference to our Flutter plugin
	var flutterPlugin = Engine.get_singleton("FlutterGodotPlugin")
	if flutterPlugin:
		print("Flutter plugin is available")
		
		# Connect to signals from Flutter
		flutterPlugin.connect("flutter_to_godot_signal", _on_message_from_flutter)
	else:
		print("Flutter plugin is not available")

# Handler for messages coming from Flutter
func _on_message_from_flutter(message):
	print("Message from Flutter: ", message)
	
	# Process the message here
	# ...
	
	# Optionally send a response back to Flutter
	var flutterPlugin = Engine.get_singleton("FlutterGodotPlugin")
	if flutterPlugin:
		flutterPlugin.sendMessageToFlutter("Response from Godot")

# Function to send a message to Flutter at any time
func send_to_flutter(message):
	var flutterPlugin = Engine.get_singleton("FlutterGodotPlugin")
	if flutterPlugin:
		flutterPlugin.sendMessageToFlutter(message)
		
