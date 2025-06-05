extends Control

@onready var minimap: PanelContainer = $"../Minimap"
@onready var score: Label = $ColorRect/Score
@onready var big_map: Control = $"../BigMap"
@onready var inventory: Control = $Inventory

@onready var interact: Button = $"../Interact"
@onready var add_point: Control = $"../AddPoint"
@onready var quest_log: Control = $QuestLog
@onready var settings: Control = $SettingsMenu

var debug_enabled := false  # Toggle this to enable/disable debugging

# Paused by other menus
var paused: bool = false

# Paused by self
var _is_paused: bool = false:
	set = set_paused

func _unhandled_input(event: InputEvent) -> void:	
	if paused or inventory.visible or quest_log.visible or settings.visible:
		if debug_enabled: print("[PauseMenu] VISIBILITY inventroy: ", inventory.visible, " quest_log: ", quest_log.visible,  " settings: ", settings.visible,)
		if debug_enabled: print("[PauseMenu] Input ignored due to another UI element being visible.")
		return

	if event.is_action_pressed("esc"):
		if debug_enabled: print("[PauseMenu] VISIBILITY inventroy: ", inventory.visible, " quest_log: ", quest_log.visible,  " settings: ", settings.visible,)
		if debug_enabled: print("[PauseMenu] ESC key pressed.")
		if not _is_paused:
			if debug_enabled: print("[PauseMenu] Pausing game.")
			_on_menu_button_pressed()
		else:
			if debug_enabled: print("[PauseMenu] Resuming game from ESC key.")
			_on_resume_pressed()

func set_paused(value: bool) -> void:
	if debug_enabled: print("[PauseMenu] set_paused called with value:", value)
	update_score_label()
	_is_paused = value

	if !GameState.is_mobile:
		minimap.visible = not value
		add_point.visible = not value
		if debug_enabled: print("[PauseMenu] Minimap and AddPoint visibility set to:", not value)
	else:
		interact.visible = not value
		if debug_enabled: print("[PauseMenu] Interact button visibility set to:", not value)

	get_tree().paused = _is_paused
	visible = _is_paused
	if debug_enabled: print("[PauseMenu] Tree paused state:", get_tree().paused, "UI visible:", visible)

func _on_resume_pressed() -> void:
	if debug_enabled: print("[PauseMenu] _on_resume_pressed called.")
	_is_paused = false
	get_tree().paused = _is_paused
	GameState.set_mouse_state(GameState.MouseState.GAMEPLAY)
	SoundManager.exit_pause_music()
	
	if !GameState.is_mobile:
		minimap.visible = true
		add_point.visible = true
		if debug_enabled: print("[PauseMenu] Resuming: showing minimap and add_point.")
	else:
		interact.visible = true
		if debug_enabled: print("[PauseMenu] Resuming: showing interact button.")

	

func _on_quit_game_pressed() -> void:
	if debug_enabled: print("[PauseMenu] Quit game pressed. Saving game...")
	var save_success = await GameState.save_game()
	if save_success:
		print("[PauseMenu] Save successful. Quitting game.")
		GameState.quit_game()
	else:
		print("[PauseMenu] Save failed. Game will not quit.")

func update_score_label():
	score.text = "Current score: %d" % GameState.score
	if debug_enabled: print("[PauseMenu] Score label updated to:", score.text)

func _on_open_map_pressed() -> void:
	big_map.visible = true
	if debug_enabled: print("[PauseMenu] Big map opened.")

func _on_menu_button_pressed() -> void:
	_is_paused = true
	SoundManager.play_pause_music()
	GameState.set_mouse_state(GameState.MouseState.UI)
	if debug_enabled: print("[PauseMenu] Menu button pressed. Game paused.")

func _on_inventory_pressed() -> void:
	inventory.visible = true
	if debug_enabled: print("[PauseMenu] Inventory opened.")

func _on_quest_log_pressed() -> void:
	quest_log.visible = true
	if debug_enabled: print("[PauseMenu] Quest log opened.")

func _on_settings_pressed() -> void:
	settings.pause_menu = self
	settings.visible = true
	if debug_enabled: print("[PauseMenu] Settings menu opened and linked.")
