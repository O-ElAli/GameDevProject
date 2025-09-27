extends Resource
class_name QuestData

@export var quest_id: String
@export var npc_name: String
@export var required_item: String = ""
@export var required_state: String = "default"
@export var new_state: String = "quest_complete"
@export var rewards: Array[String] = []  # Items to give player
