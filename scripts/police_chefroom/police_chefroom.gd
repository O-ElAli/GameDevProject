extends Node2D

@onready var silverarm = $silverarm


const SILVERARM_FIRST_DIALOGUE = {
	"npc_name": "Police Chief Silverarm",
	"dialogue_lines": [
		{"name": "Player", "text": "Hey Silverarm, I need a favor. You have a USB stick I urgently need."},
		{"name": "Silverarm", "text": "Why should I give it to you? That’s stolen property."},
		{"name": "Player", "text": "It’s about a NeoCorp conspiracy… they’re also responsible for my brother."},
		{"name": "Silverarm", "text": "NeoCorp… wait… you look familiar. Are you the younger brother of the detective who passed away? He told me something about Project Nocturne, something that could throw the world into chaos."},
		{"name": "Silverarm", "text": "Your brother helped me a lot back in the day… I’ll return the favor. You can have the USB."},
		{"name": "Player", "text": "Okay, where is it?"},
		{"name": "Silverarm", "text": "There’s a small problem. The USB is in the archive, but the androids are acting up. I don’t know what’s going on. Can you wait until we get them under control tomorrow?"},
		{"name": "Player", "text": "No, time is running out."},
		{"name": "Silverarm", "text": "Alright… here’s the keycard for the archive. If you really want to risk your life: good luck!"},
	]
}

const SILVERARM_REPEAT_DIALOGUE = {
	"npc_name": "Police Chief Silverarm",
	"dialogue_lines": [
		{"name": "Silverarm", "text": "Think carefully before you rush in. That archive isn’t a playground."}
	]
}

func _ready():
	if silverarm and silverarm is Pickup:
		silverarm.connect("interaction_finished", Callable(self, "_on_silverarm_interacted"))

func _on_silverarm_interacted(interacted_item_name: String) -> void:
	if interacted_item_name != silverarm.item_name:
		return

	var dialogue = get_node("Dialogue")
	var hud = get_tree().get_first_node_in_group("playerHUD")
	var dialogue_to_use: Dictionary

	if not SceneManager.silverarm:
		dialogue_to_use = SILVERARM_FIRST_DIALOGUE
		SceneManager.set_flag("silverarm", true)
		SceneManager.set_flag("police_back", true)
		SceneManager.silverarm = true
		if hud:
			hud.update_mission("Acquire The USB stick")
	else:
		dialogue_to_use = SILVERARM_REPEAT_DIALOGUE

	if dialogue and dialogue_to_use:
		dialogue.start_dialogue(dialogue_to_use)
		await dialogue.dialogue_finished
