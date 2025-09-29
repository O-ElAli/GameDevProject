extends Node2D

@onready var door_policetop: Door = $TopDoor

func _ready():
	if door_policetop:
		door_policetop.connect("blocked", Callable(self, "_on_door_blocked"))


func _on_door_blocked():
	var dialogue = get_node("Dialogue")
	dialogue.start_dialogue({
		"npc_name": "Player",
		"dialogue_lines": [{"name": "Player", "text": "I can’t go in there yet."}]
	})
