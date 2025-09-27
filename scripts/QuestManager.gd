extends Node
class_name QuestManager

static var quests_database = {}  # quest_id -> QuestData

static func register_quest(quest_data: QuestData):
	quests_database[quest_data.quest_id] = quest_data

# Generic function that works for ANY NPC
static func try_complete_quest(npc_name: String) -> bool:
	# Find all quests for this NPC
	for quest_id in quests_database:
		var quest = quests_database[quest_id]
		if quest.npc_name == npc_name:
			if _can_complete_quest(quest):
				_complete_quest(quest)
				return true
	return false

static func _can_complete_quest(quest: QuestData) -> bool:
	# Check if player has required item and NPC is in required state
	var has_item = quest.required_item == "" or GameState.has_item(quest.required_item)
	var correct_state = GameState.get_npc_state(quest.npc_name) == quest.required_state
	return has_item and correct_state

static func _complete_quest(quest: QuestData):
	# Remove required item
	if quest.required_item != "":
		GameState.remove_item(quest.required_item)
	
	# Change NPC state
	GameState.set_npc_state(quest.npc_name, quest.new_state)
	
	# Give rewards
	for reward in quest.rewards:
		GameState.add_item(reward)
	
	print("Quest completed: ", quest.quest_id)
