extends Node

signal inventory_updated
signal bug_visible

# Keep track of number of items in inventory
var inventory: = {
	"key": 0.0,
	"wallet": 0.0,
	"book": [],
	"food": [],
	"coffee": []
}

# Keeps track of picked up items
var picked_up_items := []
var food_orders := []

# Keeps track of the bug quest
var bug_state = {
	"quest_given": false,
	"found": false,
	"reported": false
}

func get_item_count(item_name: String) -> int:
	if not inventory.has(item_name):
		return 0
	
	var value = inventory[item_name]
	
	match typeof(value):
		TYPE_FLOAT:
			return value
		TYPE_ARRAY:
			return value.size()
		_:
			return 0

# Add certain item to inventory
func add_item(item_name: String, item_detail: String = "") -> void:
	if not inventory.has(item_name):
		return
	
	var value = inventory[item_name]
	print(item_name, " ", item_detail)
	
	if typeof(value) == TYPE_FLOAT:
		inventory[item_name] += 1
	elif typeof(value) == TYPE_ARRAY:
		if item_detail != "":
			inventory[item_name].append(item_detail)
	
	print(inventory["food"])
	inventory_updated.emit()
		
# Remove certain item from inventory
func remove_item(item_name: String, item_detail: String = "") -> void:
	if not inventory.has(item_name):
		return
	
	var value = inventory[item_name]
	
	if typeof(value) == TYPE_FLOAT:
		inventory[item_name] -= 1
	elif typeof(value) == TYPE_ARRAY:
		if item_name == "book":
			inventory[item_name].clear()
		elif item_detail != "":
			inventory[item_name].erase(item_detail)
	
	print(inventory["coffee"].size())
	inventory_updated.emit()
	
# When bug quest is done, creators are removed from game
func remove_creators():
	var cur_scene = get_tree().current_scene
	var creators = cur_scene.get_node("Creators")
	creators.visible = false
