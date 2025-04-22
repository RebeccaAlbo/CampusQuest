extends Area3D

@onready var big_map: Control = $"../CanvasLayer/BigMap"

func _ready():
	mouse_entered.connect(_on_hover_start)
	mouse_exited.connect(_on_hover_end)

func _on_hover_start():
	print("hovering: ", self.name)

func _on_hover_end():
	print("stoped hovering: ", self.name)
	
func _on_mouse_entered() -> void:
	print("hovering: ", self.name)
