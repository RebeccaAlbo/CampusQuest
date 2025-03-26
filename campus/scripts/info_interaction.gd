extends Area3D

@onready var dialog_manager = get_node("../Manager") 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_body_entered(_body: Node3D) -> void:
	print("start info dialog")
	dialog_manager.start_dialog(0)

func _on_body_exited(_body: Node3D) -> void:
	print("end info dialog")
	dialog_manager.end_dialog()
