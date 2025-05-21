extends Campus

@onready var book_box: StaticBody3D = $bookBox
@onready var food_stall: StaticBody3D = $foodStall
@onready var bug: StaticBody3D = $bug
@onready var key_kuggen: Node3D = $keyKuggen
@onready var wallet_math: Node3D = $walletMath
@onready var bus_stop: StaticBody3D = $busStop
@onready var characters: Node3D = $characters



func _ready():
	super._ready()
	SoundManager.play_lindholmen_music()
	# Adaptations for mobile version
	if GameState.is_mobile:
		for npc in characters.get_children():
			npc.scale = Vector3(5, 5, 5)
		base_character.scale = Vector3(5, 5, 5)
		base_character.get_child(1).scale(0.5, 0.5, 0.5)
		bug.scale = Vector3(5, 5, 5)
		book_box.scale = Vector3(3, 3, 3)
		food_stall.scale = Vector3(3, 3, 3)
		key_kuggen.scale = Vector3(6, 6, 6)
		wallet_math.scale = Vector3(3, 3, 3)
		bus_stop.scale = Vector3(3, 3, 3)
	
	if MiniQuests.bug_state["found"]:
		characters.get_node("creators").visible = false
