extends Control

@onready var minimap: PanelContainer = $"../Minimap"
@onready var score: Label = $ColorRect/Score
@onready var big_map: Control = $"../BigMap"
@onready var inventory: Control = $Inventory

@onready var interact: Button = $"../Interact"
@onready var add_point: Control = $"../AddPoint"
@onready var quest_log: Control = $QuestLog



# Paused by other menues
var paused: bool = false
# Paused by self
var _is_paused: bool = false:
	set = set_paused

# Handles the "esc" key input to toggle the pause state, show/hide the minimap, 
# and control mouse visibility
func _unhandled_input(event: InputEvent) -> void:	
	if paused or inventory.visible or quest_log.visible:
		return
	
	if event.is_action_pressed("esc"):
		if _is_paused == false:
			SoundManager.play_pause_music()
			_is_paused =  true
			GameState.set_mouse_state(GameState.MouseState.UI)
		else:
			_on_resume_pressed()
			

# Sets the paused state, hides the minimap, updates the game pause state, 
#and controls the visibility of the UI
func set_paused(value:bool) -> void:
	update_score_label()
	_is_paused = value
	if !GameState.is_mobile:
		minimap.visible = false
		add_point.visible = false
	else:
		interact.visible = false
	get_tree().paused = _is_paused
	visible = _is_paused

# Resumes the game by unpausing the game state, showing the minimap, and capturing the mouse
func _on_resume_pressed() -> void:
	_is_paused = false
	get_tree().paused = _is_paused
	GameState.set_mouse_state(GameState.MouseState.GAMEPLAY)
	if !GameState.is_mobile:
		minimap.visible = true
		add_point.visible = true
	else:
		interact.visible = true
	SoundManager.exit_pause_music()

# Saves the game and quits the application
func _on_quit_game_pressed() -> void:
	var save_success = await GameState.save_game()
	if save_success:
		print("[Godot pause_menu] Save successful.")
		GameState.quit_game()
	else:
		print("[Godot pause_menu] Save failed.")


# Updates the score label with the current score value from the game state
func update_score_label():
	score.text = "Current score: %d" %GameState.score

func _on_open_map_pressed() -> void:
	big_map.visible = true

func _on_menu_button_pressed() -> void:
	print("menu button pressed")
	_is_paused = true
	
func _on_inventory_pressed() -> void:
	inventory.visible = true
	
func _on_quest_log_pressed() -> void:
	quest_log.visible = true
