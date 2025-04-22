extends Node

var score = 0
var talked_to_npcs = {}

func add_npc_point(npc: Node):
	if not talked_to_npcs.has(npc.name):
		talked_to_npcs[npc.name] = true
		score += 1
		print("score: ", score)
		
func save_game():
	var save_data = {
		"score": score,
		"talked_to_npcs": talked_to_npcs,
		"player_appearance": {
			"shirt": CharacterCust.shirt_index,
			"hair": CharacterCust.hair_index,
			"skin": CharacterCust.skin_index,
			"pant": CharacterCust.pant_index,
			"shoes": CharacterCust.shoes_index
		}
	}
	
	var json_data = JSON.stringify(save_data)
	var file = FileAccess.open("user://save_game.json", FileAccess.WRITE)
	file.store_string(json_data)
	file.close()
	print("game saved")
	
func load_game():
	if FileAccess.file_exists("user://save_game.json"):
		var file = FileAccess.open("user://save_game.json", FileAccess.READ)
		var json = JSON.new()
		var result = json.parse(file.get_as_text())
		file.close()
		
		if result == OK:
			var save_data = json.get_data()
			file.close()
			
			score = save_data.get("score", 0)
			talked_to_npcs = save_data.get("talked_to_npcs", {})
		
			var appearance = save_data.get("player_appearance", {})
			CharacterCust.shirt_index = appearance.get("shirt", 0)
			CharacterCust.hair_index = appearance.get("hair", 0)
			CharacterCust.skin_index = appearance.get("skin", 0)
			CharacterCust.pant_index = appearance.get("pant", 0)
			CharacterCust.shoes_index = appearance.get("shoes", 0)
		
		
	else:
		print("no saved file")
		
		
