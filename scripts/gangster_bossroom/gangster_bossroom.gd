extends Node2D

@onready var gangster_boss = $gangster_boss


const BOSS_FIRST_DIALOGUE = {
	"npc_name": "Yakuza Boss",
	"dialogue_lines": [
		{"name": "Kurogane", "text": "Ah… you survived the arena. You show potential, just like your brother."},
		{"name": "Player", "text": "What do you know about my brother? What happened to him?"},
		{"name": "Kurogane", "text": "Your brother was here to meet a maid, she had information important to him. She was being pursued, so we hid her here. But she disappeared without telling anyone. The only thing I know is that NeoCorp is behind it. Those filthy rats are still among us."},
		{"name": "Kurogane", "text": "Check the Maid Cafe—you might find clues there. Show me if you’re as good a detective as your brother. And when you find NeoCorp’s hideout, let me know. I’ll help you take out the rats."}
	]
}

const BOSS_REPEAT_DIALOGUE = {
	"npc_name": "Yakuza Boss",
	"dialogue_lines": [
		{"name": "Kurogane", "text": "Good luck!"}
	]
}

func _ready():
	if gangster_boss and gangster_boss is Pickup:
		gangster_boss.connect("interaction_finished", Callable(self, "_on_boss_interacted"))

func _on_boss_interacted(interacted_item_name: String) -> void:
	if interacted_item_name != gangster_boss.item_name:
		return

	var dialogue = get_node("Dialogue")
	var hud = get_tree().get_first_node_in_group("playerHUD")
	var dialogue_to_use: Dictionary

	if not SceneManager.boss:
		dialogue_to_use = BOSS_FIRST_DIALOGUE
		SceneManager.set_flag("boss", true)
		SceneManager.set_flag("maid", true)
		SceneManager.boss = true
		if hud:
			hud.update_mission("Go to the Maid Cafe!")
	else:
		dialogue_to_use = BOSS_REPEAT_DIALOGUE

	if dialogue and dialogue_to_use:
		dialogue.start_dialogue(dialogue_to_use)
		await dialogue.dialogue_finished
