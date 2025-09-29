extends Node2D

@onready var player = $Player
@onready var dialogue = $Dialogue

func _ready():
	if not SceneManager.bar_main_intro_done:
		SceneManager.bar_main_intro_done = true
		_intro_sequence()

func _intro_sequence() -> void:
	player.set_movement_allowed(false)

	var bar_main_intro_dialogue = {
		"npc_name": "Player",
		"dialogue_lines": [
			{"name": "Navi", "text": "Clyde has to be around here somewhere."},
		]
	}
	dialogue.start_dialogue(bar_main_intro_dialogue)
	await dialogue.dialogue_finished
	player.set_movement_allowed(true)
