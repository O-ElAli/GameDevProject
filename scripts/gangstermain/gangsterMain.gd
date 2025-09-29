extends Node2D

@onready var door_basement: Door = $Basement

func _ready():
	if door_basement:
		door_basement.connect("blocked", Callable(self, "_on_door_blocked"))


func _on_door_blocked():
	var dialogue = get_node("Dialogue")
	dialogue.start_dialogue({
		"npc_name": "Player",
		"dialogue_lines": [{"name": "Player", "text": "I can’t go in there yet."}]
	})
