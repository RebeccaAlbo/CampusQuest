extends Control

@onready var pause_menu: Control = $"../PauseMenu"
@onready var minimap: PanelContainer = $"../Minimap"

func _on_exit_pressed() -> void:
	self.visible = false
	pause_menu.paused = false
	if !GameState.is_mobile:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		minimap.visible = true
