extends Node
class_name QuestDatabase

static var QUESTS = {
	"beer_quest": {
		"npc_name": "Beggar",
		"required_item": "beer",
		"required_state": "default",
		"new_state": "after_beer",
		"rewards": ["gold_coin"]
	},
	"thank_you_quest": {
		"npc_name": "Beggar", 
		"required_item": "",  # No item needed, just time-based
		"required_state": "after_beer",
		"new_state": "quest_complete",
		"rewards": ["special_item"]
	},
	# NEW QUESTS FOR IGOR:
	"start_igor_quest": {
		"npc_name": "Igor",
		"required_item": "",  # No item needed to start quest
		"required_state": "greeting", 
		"new_state": "quest_started",
		"rewards": []  # No reward for starting, only for completing
	},
	"complete_igor_quest": {
		"npc_name": "Igor",
		"required_item": "ancient_relic",  # Item from cave
		"required_state": "quest_started",
		"new_state": "quest_complete", 
		"rewards": ["magic_sword", "gold_coins"]
	}
}

static func get_quests_for_npc(npc_name: String) -> Array:
	var npc_quests = []
	for quest_id in QUESTS:
		if QUESTS[quest_id]["npc_name"] == npc_name:
			npc_quests.append(quest_id)
	return npc_quests

static func get_quest_data(quest_id: String) -> Dictionary:
	return QUESTS.get(quest_id, {})

static func try_complete_quests(npc_name: String) -> bool:
	print("=== QUEST DEBUG ===")
	print("Checking quests for NPC: ", npc_name)
	
	var npc_quests = get_quests_for_npc(npc_name)
	print("Found quests for this NPC: ", npc_quests)
	
	# ONLY COMPLETE THE FIRST ELIGIBLE QUEST
	for quest_id in npc_quests:
		var quest = get_quest_data(quest_id)
		print("--- Checking quest: ", quest_id, " ---")
		
		# Check if quest can be completed
		var required_item = quest.get("required_item", "")
		var has_item = true  # Assume true if no item required

		if required_item != "":  # Only check if item is actually required
			has_item = GameState.has_item(required_item)
		var correct_state = GameState.get_npc_state(npc_name) == quest.get("required_state", "default")
		
		print("Has required item? ", has_item)
		print("NPC in correct state? ", correct_state)
		print("Current NPC state: '", GameState.get_npc_state(npc_name), "'")
		print("Required state: '", quest.get("required_state", "default"), "'")
		print("States match? ", GameState.get_npc_state(npc_name) == quest.get("required_state", "default"))
		print("All NPC states in GameState: ", GameState.npc_states)  # ADD THIS LINE
		
		if has_item and correct_state:
			# Complete the quest
			if quest.has("required_item") and quest["required_item"] != "":
				GameState.remove_item(quest["required_item"])
			
			GameState.set_npc_state(npc_name, quest.get("new_state", "default"))
			
			if quest.has("rewards"):
				for reward in quest["rewards"]:
					GameState.add_item(reward)
			
			print("✅ QUEST COMPLETED: ", quest_id)
			print("=== END QUEST DEBUG ===")
			return true  # RETURN AFTER FIRST QUEST COMPLETION
		else:
			print("❌ Quest conditions not met")
	
	print("=== END QUEST DEBUG ===")
	return false
