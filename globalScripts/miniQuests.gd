extends Node

signal inventory_updated

var inventory: = {
	"key": 0,
	"wallet": 0,
	"book": 0,
	"food": 0,
	"coffee": 0
}

var picked_up_items := []

func add_item(item_name: String) -> void:
	if inventory.has(item_name):
		inventory[item_name] += 1
		inventory_updated.emit()
		
func remove_item(item_name: String) -> void:
	if inventory.has(item_name):
		inventory[item_name] -= 1
		inventory_updated.emit()
