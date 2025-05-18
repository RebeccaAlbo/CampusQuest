extends Node

signal inventory_updated
signal bug_visible
signal quest_started(desc: String)
signal quest_finished(desc: String)

# Keep track of number of items in inventory
var inventory: = {
	"key": 0.0,
	"wallet": 0.0,
	"book": [],
	"food": [],
	"coffee": []
}

# Keeps track of quests
var picked_up_items := []
var food_orders := []
var started_quests := []
var finished_quests := []

# Keeps track of the bug quest
var bug_state = {
	"quest_given": false,
	"found": false,
	"reported": false
}

# Quest descriptions for Quest Log
var quest_description := [
	{
		"id": "keyKuggen",
		"desc": "Find the lost key around Jupiter and give it to Kuggen"
	},
	{
		"id": "book",
		"desc": "You have books to return to the library"
	},
	{
		"id": "keyChemistry",
		"desc": "Find a lost key near MC2 building and return to the department of Chemistry"
	},
	{
		"id": "foodLife",
		"desc": "Pick up lunch and give it to the department of Life Sciences"
	},
	{
		"id": "walletMath",
		"desc": "Find the lost wallet near Äran and return it to the department of Mathematical sciences"
	},
	{
		"id": "coffeeSvea",
		"desc": "Bring coffee to Svea"
	},
	{
		"id": "foodJupiter",
		"desc": "Pick up lunch and give it to Jupiter"
	},
	{
		"id": "bug",
		"desc": "Find the missing bug near the water and report back to Rebecca and Amanda"
	},
	{
		"id": "coffeeSaga",
		"desc": "Bring coffee to the department of Physics"
	},
	{
		"id": "walletSpace",
		"desc": "Find the lost wallet near MV and return it to the department of Space"
	},
]

func add_started_quest(id: String):
	started_quests.append(id)
	quest_started.emit()
	print(started_quests)
	
func add_finished_quest(id: String):
	started_quests.erase(id)
	if id == "book":
		for book in inventory["book"]:
			finished_quests.append(book)
		remove_item("book")
	else:
		finished_quests.append(id)
	quest_finished.emit()

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
	
	if typeof(value) == TYPE_ARRAY:
		if item_name == "book":
			inventory[item_name].clear()
		elif item_detail != "":
			inventory[item_name].erase(item_detail)
	else: 
		if get_item_count(item_name) > 0:
			inventory[item_name] -= 1.0
			print("removing: ", item_name)
			
	inventory_updated.emit()
	
# When bug quest is done, creators are removed from game
func remove_creators():
	var cur_scene = get_tree().current_scene
	var creators = cur_scene.get_node("Creators")
	creators.visible = false
