extends Node

# Track quest states and NPC relationships
var npc_states = {}  # Format: { "Beggar": "after_beer", "Igor": "quest_complete" }
var inventory = []   # Track items player has

func set_npc_state(npc_name: String, state: String):
	npc_states[npc_name] = state
	print("NPC state updated: ", npc_name, " -> ", state)

func get_npc_state(npc_name: String) -> String:
	return npc_states.get(npc_name, "default")

func add_item(item_name: String):
	if not item_name in inventory:
		inventory.append(item_name)
	print("Item added to inventory: ", item_name)

func has_item(item_name: String) -> bool:
	return item_name in inventory

func remove_item(item_name: String):
	if item_name in inventory:
		inventory.erase(item_name)
		print("Item removed from inventory: ", item_name)
