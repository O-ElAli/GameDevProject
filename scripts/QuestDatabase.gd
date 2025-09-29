extends Node
class_name QuestDatabase

static var QUESTS = {
	"beer_quest": {
		"npc_name": "Beggar",
		"required_item": "beer",
		"completion_state": "after_beer"
	},
	"relic_quest": {
		"npc_name": "Igor", 
		"required_item": "ancient_relic",
		"completion_state": "quest_complete"
	}
}

static func try_complete_quest(npc_name: String) -> bool:
	print("=== QUEST CHECK ===")
	print("Checking quests for: ", npc_name)
	
	# Find quest for this NPC
	for quest_id in QUESTS:
		var quest = QUESTS[quest_id]
		if quest["npc_name"] == npc_name:
			print("Found quest: ", quest_id)
			print("Required item: ", quest["required_item"])
			print("Player has item: ", GameState.has_item(quest["required_item"]))
			
			# Check if player has the required item
			if GameState.has_item(quest["required_item"]):
				# Complete the quest
				GameState.remove_item(quest["required_item"])
				GameState.set_npc_state(npc_name, quest["completion_state"])
				print("✅ QUEST COMPLETED: ", quest_id)
				return true
	
	print("No quest completed")
	return false
