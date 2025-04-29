extends Control

@onready var pause_menu: Control = $"../PauseMenu"
@onready var minimap: PanelContainer = $"../Minimap"

func _on_exit_pressed() -> void:
	self.visible = false
	pause_menu.paused = false
	GameState.set_mouse_state(GameState.MouseState.GAMEPLAY)
	if !GameState.is_mobile:
		minimap.visible = true
