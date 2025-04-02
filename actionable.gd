extends Area3D

@export var dialoque_resrouce : DialogueResource
@export var dialoque_start : String = "start"

func action() -> void:
	var npc = get_parent()
	npc.animation("Talking", 0.3)
	DialogueManager.show_example_dialogue_balloon(dialoque_resrouce, dialoque_start)
	
