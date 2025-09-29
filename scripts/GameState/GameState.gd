
extends Node


var npc_state: Dictionary = {
	"Igor": 0, 
	"ShopKeeper": 0
}


func set_npc_progress(npc_id: String, state_value: int):
	if npc_state.has(npc_id):
		npc_state[npc_id] = state_value
		print("Fortschritt für ", npc_id, " auf ", state_value, " gesetzt.")
