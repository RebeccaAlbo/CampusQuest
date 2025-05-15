extends Control

@onready var key: Label = $Panel/AmountContainer/Key
@onready var coffee: Label = $Panel/AmountContainer/Coffee
@onready var food: Label = $Panel/AmountContainer/Food
@onready var book: Label = $Panel/AmountContainer/Book
@onready var wallet: Label = $Panel/AmountContainer/Wallet
@onready var pause_menu: Control = $".."



func _ready():
	MiniQuests.inventory_updated.connect(_update_labels)
	_update_labels()


func _update_labels():
	key.text = str(MiniQuests.get_item_count("key"))
	coffee.text = str(MiniQuests.get_item_count("coffee"))
	food.text = str(MiniQuests.get_item_count("food"))
	book.text = str(MiniQuests.get_item_count("book"))
	wallet.text = str(MiniQuests.get_item_count("wallet"))
	

func _on_exit_pressed() -> void:
	self.visible = false
	pause_menu.paused = false
