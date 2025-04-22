extends Panel

@onready var label: Label = $Label

func _on_mouse_entered() -> void:
	label.visible = true

func _on_mouse_exited() -> void:
	label.visible = false
