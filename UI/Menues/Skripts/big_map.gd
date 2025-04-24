extends Control

@onready var pause_menu: Control = $"../PauseMenu"


# Handles user input to toggle pause state and control minimap visibility
func _unhandled_input(event: InputEvent) -> void:	
	if event.is_action_pressed("esc"):
		self.visible = false
		pause_menu.visible = true
	
	
func _on_go_back_pressed() -> void:
	self.visible = false
	pause_menu.visible = true
