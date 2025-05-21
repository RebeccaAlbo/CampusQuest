extends Campus

@onready var characters: Node3D = $characters
@onready var wallet_space: Node3D = $walletSpace
@onready var bus_stop: StaticBody3D = $busStop
@onready var food_stall: StaticBody3D = $foodStall
@onready var key_chemistry: Node3D = $keyChemistry
@onready var book_box: StaticBody3D = $bookBox


func _ready():
	super._ready()
	SoundManager.play_johanneberg_music()
	
	if GameState.is_mobile:
		for npc in characters.get_children():
			npc.scale = Vector3(5, 5, 5)
		base_character.scale = Vector3(5, 5, 5)
		book_box.scale = Vector3(3, 3, 3)
		food_stall.scale = Vector3(3, 3, 3)
		key_chemistry.scale = Vector3(6, 6, 6)
		wallet_space.scale = Vector3(3, 3, 3)
		bus_stop.scale = Vector3(3, 3, 3)
	
