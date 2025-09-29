extends Node2D


@onready var door_boss: Door = $BossRoom
@onready var warden = $Warden

const WARDEN_FIRST_DIALOGUE = {
	"npc_name": "Bodyguard",
	"dialogue_lines": [
		{"name": "Bodyguard", "text": "Hey! The tournament has already started, you can't get in. Maybe try through the basement? Hahaha!"},
		{"name": "Player", "text": "Through the basement… that could be a possibility."},
		{"name": "Navi", "text": "Well, if you go through the basement, don’t blame me if you find rats in tuxedos!"}
	]
}

const WARDEN_REPEAT_DIALOGUE = {
	"npc_name": "Bodyguard",
	"dialogue_lines": [
		{"name": "Bodyguard", "text": "Move along, now! No more shortcuts."}
	]
}

func _ready():
	if warden and warden is Pickup:
		warden.connect("interaction_finished", Callable(self, "_on_warden_interacted"))
	if door_boss:
		door_boss.connect("blocked", Callable(self, "_on_door_blocked"))

func _on_door_blocked():
	var dialogue = get_node("Dialogue")
	dialogue.start_dialogue({
		"npc_name": "Player",
		"dialogue_lines": [{"name": "Player", "text": "Its Locked."}]
	})

func _on_warden_interacted(interacted_item_name: String):
	if interacted_item_name != warden.item_name:
		return

	var dialogue = get_node("Dialogue")
	var hud = get_tree().get_first_node_in_group("playerHUD")
	var dialogue_to_use: Dictionary

	if not SceneManager.warden:
		dialogue_to_use = WARDEN_FIRST_DIALOGUE
		SceneManager.set_flag("warden", true)
		SceneManager.set_flag("basement", true)
		SceneManager.warden = true
		if hud:
			hud.update_mission("The Basement?")
	else:
		dialogue_to_use = WARDEN_REPEAT_DIALOGUE

	if dialogue and dialogue_to_use:
		dialogue.start_dialogue(dialogue_to_use)
		await dialogue.dialogue_finished
