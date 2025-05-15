extends Control

@onready var quest_descriptions: Label = $Panel/QuestDescriptions



func _ready() -> void:
	MiniQuests.quest_started.connect(update_quest)
	MiniQuests.quest_finished.connect(update_quest)
	update_quest()
	

func update_quest():
	print("updating quests...")
	var text:= ""
	for id in MiniQuests.started_quests:
		for q in MiniQuests.quest_description:
			if q["id"] == id:
				text = q["desc"]
				break
		break
	quest_descriptions.text = text if text != "" else "No active quests"

func _on_exit_pressed() -> void:
	self.visible = false
