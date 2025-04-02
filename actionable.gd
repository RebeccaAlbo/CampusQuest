extends Area3D

@export var dialoque_resrouce : DialogueResource
@export var dialoque_start : String = "start"

func action() -> void:
	DialogueManager.show_example_dialogue_balloon(dialoque_resrouce, dialoque_start)
