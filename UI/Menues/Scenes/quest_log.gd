extends Control

@onready var quest_descriptions: Label = $Panel/QuestDescriptions
@onready var pause_menu: Control = $".."



func _ready() -> void:
	MiniQuests.quest_started.connect(update_quest)
	MiniQuests.quest_finished.connect(update_quest)
	update_quest()
	

func update_quest():
	# Allthough there are several book quests, they all have same description, therefor +3
	var total_quest_count = MiniQuests.quest_description.size() + 3
	var finished_quest_count = MiniQuests.finished_quests.size()
	var text:= ""
	for id in MiniQuests.started_quests:
		for q in MiniQuests.quest_description:
			if q["id"] == id:
				text += "• " + q["desc"] + "\n"
				break
	if text != "":
		quest_descriptions.text = text 
	elif total_quest_count == finished_quest_count:
		quest_descriptions.text = "You have finished all quests"
	else:
		quest_descriptions.text = "No active quests"

func _on_exit_pressed() -> void:
	self.visible = false
	pause_menu.paused = false
