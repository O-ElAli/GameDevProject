extends Node2D

@onready var bonnie = $Bonnie


const BONNIE_FIRST_DIALOGUE = {
	"npc_name": "Bonnie",
	"dialogue_lines": [
		{"name": "Player", "text": "So, you’re Bonnie… and where’s Clyde?"},
		{"name": "Bonnie", "text": "Ah, the detective. Yes, I know something. We managed to hack the location of NeoCorp’s hideout and stored the data on a USB stick. Unfortunately, the Police Chief, Silverarm, got his hands on it."},
		{"name": "Bonnie", "text": "Clyde managed to escape before the police closed in. He’s hiding out in a bar somewhere, but he doesn’t have the USB. He’s the only one who can decrypt it once we get it back."},
		{"name": "Navi", "text": "So Clyde’s safe, the stick’s with the police… and somehow we’re supposed to fix this? Great, just another normal day in the city."}
	]
}

const BONNIE_REPEAT_DIALOGUE = {
	"npc_name": "Bonnie",
	"dialogue_lines": [
		{"name": "Bonnie", "text": "I’ve already told you everything."}
	]
}

func _ready():
	if bonnie and bonnie is Pickup:
		bonnie.connect("interaction_finished", Callable(self, "_on_bonnie_interacted"))

func _on_bonnie_interacted(interacted_item_name: String) -> void:
	if interacted_item_name != bonnie.item_name:
		return

	var dialogue = get_node("Dialogue")
	var hud = get_tree().get_first_node_in_group("playerHUD")
	var dialogue_to_use: Dictionary

	if not SceneManager.bonnie:
		dialogue_to_use = BONNIE_FIRST_DIALOGUE
		SceneManager.set_flag("bonnie", true)
		SceneManager.set_flag("police_top", true)
		SceneManager.bonnie = true
		if hud:
			hud.update_mission("Talk with the Police Chef")
	else:
		dialogue_to_use = BONNIE_REPEAT_DIALOGUE

	if dialogue and dialogue_to_use:
		dialogue.start_dialogue(dialogue_to_use)
		await dialogue.dialogue_finished
