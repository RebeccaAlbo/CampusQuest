extends Campus

@onready var creators: Node3D = $Creators
@onready var svea: CharacterBody3D = $svea
@onready var kuggen: CharacterBody3D = $kuggen
@onready var jupiter: CharacterBody3D = $jupiter
@onready var saga: CharacterBody3D = $saga
@onready var patricia: CharacterBody3D = $patricia
@onready var aran: CharacterBody3D = $aran
@onready var anglia: CharacterBody3D = $anglia
@onready var book_box: StaticBody3D = $bookBox
@onready var food_stall: StaticBody3D = $foodStall
@onready var bug: StaticBody3D = $bug
@onready var key_kuggen: Node3D = $keyKuggen
@onready var wallet_math: Node3D = $walletMath

func _ready():
	super._ready()
	SoundManager.play_lindholmen_music()
	# Adaptations for mobile version
	if GameState.is_mobile:
		svea.scale = Vector3(5, 5, 5)
		kuggen.scale = Vector3(5, 5, 5)
		jupiter.scale = Vector3(5, 5, 5)
		saga.scale = Vector3(5, 5, 5)
		patricia.scale = Vector3(5, 5, 5)
		aran.scale = Vector3(5, 5, 5)
		anglia.scale = Vector3(5, 5, 5)
		base_character.scale = Vector3(5, 5, 5)
		creators.scale = Vector3(5, 5, 5)
		bug.scale = Vector3(5, 5, 5)
		bug.get_node("HoverText").visible = false
		book_box.scale = Vector3(3, 3, 3)
		book_box.get_node("HoverText").visible = false
		food_stall.scale = Vector3(3, 3, 3)
		key_kuggen.scale = Vector3(5, 5, 5)
		wallet_math.scale = Vector3(5, 5, 5)
	
	if MiniQuests.bug_state["found"]:
		creators.visible = false
