# Note: Dialogue Manager 2 mutators must return synchronously.
# Since FlutterBridge.getDialog() is asynchronous (uses await), we cannot call it directly from a {mutator(...)} line.
# Instead,we use an extra_info text label

extends Control

@onready var pause_menu: Control = $"../PauseMenu"
@onready var minimap: PanelContainer = $"../Minimap"

# Handles user input to toggle pause state and control minimap visibility
func _unhandled_input(event: InputEvent) -> void:	
	if not visible: #if extra_info is not displayed we should let pause_menu react to esc
		return
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled() # Prevents pause_menu from activating on esc and displaying ontop
		_on_exit_pressed()

func _on_exit_pressed() -> void:
	self.visible = false
	pause_menu.paused = false
	GameState.set_mouse_state(GameState.MouseState.GAMEPLAY)
	if !GameState.is_mobile:
		minimap.visible = true
		
	FlutterBridge.emit_signal("extra_info_ended")
	FlutterBridge.running_extra_info = false;
	$Panel/DataBaseText.text = ""
