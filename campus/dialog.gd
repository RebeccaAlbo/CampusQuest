extends Node

@onready var dialog_node = $Dialog  # Reference to the 2D dialog node
@onready var dialog_label = $Dialog/Label  # Reference to the label inside the dialog
var dialog_selection = ["Hej and welcome", "Hej again"]

func start_dialog(dialog_index: int):
	if dialog_index < dialog_selection.size():
		dialog_label.text = ""  # Clear previous text
		dialog_label.text = dialog_selection[dialog_index]  # Update label text
		dialog_node.visible = true  # Make the dialog visible
		print(dialog_selection[dialog_index])  # Debugging output
func end_dialog():
		dialog_label.text = ""  # Clear previous text
		dialog_node.visible = false  # Make the dialog visible
