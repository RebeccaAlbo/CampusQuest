extends Node

var score = 0
var talked_to_npcs = {}
var is_mobile := false

enum MouseState {GAMEPLAY, UI}
var current_state: MouseState = MouseState.UI

func _ready() -> void:
	if OS.get_name() == "Android":
		is_mobile = true
		
	if is_mobile:
		set_mobile_resolution()
	else:
		set_pc_resolution()

func set_mouse_state(state: MouseState):
	current_state = state
	
	match state:
		MouseState.GAMEPLAY:
			if not GameState.is_mobile:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		MouseState.UI:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Adds a point to the score for interacting with a new NPC
# Tracks the interaction to avoid repetition
func add_npc_point(npc: Node):
	if not talked_to_npcs.has(npc.name):
		talked_to_npcs[npc.name] = true
		
func add_score(s: int, npc_name: String = ""):	
	score += s
	SoundManager.play_coin()
	var scene = get_tree().current_scene
	var points_popup = scene.get_node("CanvasLayer").get_node("AddPoint").get_node("PointsPopup")
	points_popup.text = "+" + str(s) + " Point" + ("!" if score == 1 else "s!")
	points_popup.get_node("AnimationPlayer").play("popup")
	if name != "" and !talked_to_npcs.has("name"):
		talked_to_npcs[name] = true
		var npc = scene.get_node(npc_name)
		npc.change_mark()
		
		
func save_game() -> bool:
	# Creates a dictionary to store the player's score, NPC interaction data, 
	# and character customization choices for saving
	print("keys: ", MiniQuests.get_item_count("key"))
	var save_data = {
		"score": score,
		"bug_state": MiniQuests.bug_state,
		"talked_to_npcs": talked_to_npcs,
		"inventory": MiniQuests.inventory,
		"picked_up_items": MiniQuests.picked_up_items,
		"food_orders": MiniQuests.food_orders,
		"player_appearance": {
			"shirt": CharacterCust.shirt_index,
			"hair": CharacterCust.hair_index,
			"skin": CharacterCust.skin_index,
			"pant": CharacterCust.pant_index,
			"shoes": CharacterCust.shoes_index
		}
	}
	
	var json = '{"key": 1}'
	var parsed = JSON.parse_string(json)
	
	# Converts the save data to a JSON string, writes it to a file, 
	# and saves the game state to disk
	var json_data = JSON.stringify(save_data)
	var file = FileAccess.open("user://save_game.json", FileAccess.WRITE)
	file.store_string(json_data)
	file.close()
	
	# send the data to flutter 
	if (!is_mobile and FlutterBridge.web_mode):
		return await FlutterBridge.save_game(save_data)
	else: 
		return true #TODO add mobile
	
func quit_game():
	if (!is_mobile and FlutterBridge.web_mode):
		FlutterBridge.quit_game() #send back a true or false if successful
	else: #mobile 
		get_tree().quit()
	
func load_game():
	if (!is_mobile and FlutterBridge.web_mode):
		print("[Godot] Running on Web with JS available – requesting save from Flutter")
		var flutter_data = await FlutterBridge.request_game()

		if flutter_data.is_empty():
			print("[Godot] Flutter returned empty character data")
			return

		score = flutter_data.get("score", 0)
		talked_to_npcs = flutter_data.get("talked_to_npcs", {})

		MiniQuests.inventory = flutter_data.get("inventory", {})
		MiniQuests.picked_up_items = flutter_data.get("picked_up_items", [])
		MiniQuests.food_orders = flutter_data.get("food_orders", [])
		MiniQuests.bug_state = flutter_data.get("bug_state", {})

		var appearance = flutter_data.get("player_appearance", {})
		CharacterCust.shirt_index = appearance.get("shirt", 0)
		CharacterCust.hair_index = appearance.get("hair", 0)
		CharacterCust.skin_index = appearance.get("skin", 0)
		CharacterCust.pant_index = appearance.get("pant", 0)
		CharacterCust.shoes_index = appearance.get("shoes", 0)
	
	else:
		print("no saved file")
		# Fallback to local save
		if FileAccess.file_exists("user://save_game.json"):
			var file = FileAccess.open("user://save_game.json", FileAccess.READ)
			var json = JSON.new()
			var result = json.parse(file.get_as_text())
			file.close()

			if result == OK:
				var save_data = json.get_data()

				score = save_data.get("score", 0)
				talked_to_npcs = save_data.get("talked_to_npcs", {})

				MiniQuests.inventory = save_data.get("inventory", {})
				MiniQuests.picked_up_items = save_data.get("picked_up_items", [])
				MiniQuests.food_orders = save_data.get("food_orders", [])
				MiniQuests.bug_state = save_data.get("bug_state", {})

				var appearance = save_data.get("player_appearance", {})
				CharacterCust.shirt_index = appearance.get("shirt", 0)
				CharacterCust.hair_index = appearance.get("hair", 0)
				CharacterCust.skin_index = appearance.get("skin", 0)
				CharacterCust.pant_index = appearance.get("pant", 0)
				CharacterCust.shoes_index = appearance.get("shoes", 0)
		else:
			print("No saved file")

# Adjust resolution for mobile
func set_mobile_resolution():
	var mobile_resolution = Vector2i(580, 290)
	DisplayServer.window_set_size(mobile_resolution)
	
# Adjust resolution for PC
func set_pc_resolution():
	var pc_resolution = Vector2i(1000,500)
	DisplayServer.window_set_size(pc_resolution)
	
# In dialogue, show extra information about department from database
func show_extra_info(yes: bool, npc_name: String):
	FlutterBridge.running_extra_info = true;
	if yes:
		var info_node = get_tree().current_scene.get_node("CanvasLayer/ExtraInfo")
		var minimap_node = get_tree().current_scene.get_node("CanvasLayer/Minimap")
		info_node.visible = true
		minimap_node.visible = false
		#Calling some function with the name variable
		var dialog_data
		if (FlutterBridge.web_mode): 
			dialog_data = await FlutterBridge.request_dialog(npc_name)
		else: 
			dialog_data = "You are now standing before a building on Chalmers campus. Its purpose is not immediately clear, but something about it suggests there's more to discover if you take a closer look around"
		var data_label = info_node.get_node("Panel/DataBaseText")
		data_label.text = dialog_data
		FlutterBridge.play_tts(dialog_data)
