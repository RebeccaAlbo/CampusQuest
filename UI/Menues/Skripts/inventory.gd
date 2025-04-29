extends Control

@onready var key: Label = $Panel/AmountContainer/Key
@onready var coffee: Label = $Panel/AmountContainer/Coffee
@onready var food: Label = $Panel/AmountContainer/Food
@onready var book: Label = $Panel/AmountContainer/Book
@onready var wallet: Label = $Panel/AmountContainer/Wallet

func _ready():
	MiniQuests.inventory_updated.connect(_update_labels)
	_update_labels()

func _update_labels():
	key.text = str(MiniQuests.inventory.get("key", 0))
	coffee.text = str(MiniQuests.inventory.get("coffee", 0))
	food.text = str(MiniQuests.inventory.get("food", 0))
	book.text = str(MiniQuests.inventory.get("book", 0))
	wallet.text = str(MiniQuests.inventory.get("wallet", 0))
	

func _on_exit_pressed() -> void:
	self.visible = false
