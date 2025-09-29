extends Node2D

@onready var door_maid: Door = $MaidCafe
@onready var door_bar: Door = $Bar
@onready var door_police: Door = $PoliceStation
@onready var door_policeBack: Door = $PoliceBackdoor
@onready var door_gangster: Door = $Gangster
@onready var glitchy = $"Glitchy Joe"


const GLITCHY_JOE_FIRST_DIALOGUE = {
	"npc_name": "Glitchy Joe",
	"dialogue_lines": [
		{"name": "Glitchy Joe", "text": "Heeey… Broooooo. What's up?"},
		{"name": "Player", "text": "Are you Glitchy Joe?"},
		{"name": "Glitchy Joe", "text": "Depends… who’s asking? Maybe I’m Glitchy Joe, maybe just a drunk simulation."},
		{"name": "Navi", "text": "It’s him. Database match: 99.3% probability.\nThe remaining 0.7% is just alcohol."},
		{"name": "Player", "text": "Asahi."},
		{"name": "Glitchy Joe", "text": "Asooo Brooo, you must be the little brother."},
		{"name": "Player", "text": "Red. What do you know about my brother?"},
		{"name": "Glitchy Joe", "text": "Your brother was a good sleuth.\nDug in the shadows of NeoCorp… too deep.\nHe found something not meant for his eyes."},
		{"name": "Glitchy Joe","text": "Last time I saw him, he was heading toward the Yakuza warehouse…\nand he looked like he was being followed."},
		{"name": "Player", "text": "Followed? By whom?"},
		{"name": "Glitchy Joe", "text": "I won’t say more, otherwise I’ll wake up in the sewer without organs."}
	]
}

const GLITCHY_JOE_REPEAT_DIALOGUE = {
	"npc_name": "Glitchy Joe",
	"dialogue_lines": [
		{"name": "Glitchy Joe", "text": "Watch yourself, Bro!"}
	]
}

func _ready():
	if not SceneManager.citymap_intro_done:
		SceneManager.citymap_intro_done = true
		_intro_sequence()
	if glitchy and glitchy is Pickup:
		glitchy.connect("interaction_finished", Callable(self, "_on_pickup_interacted"))
	if door_maid:
		door_maid.connect("blocked", Callable(self, "_on_door_blocked"))
	if door_bar:
		door_bar.connect("blocked", Callable(self, "_on_door_blocked"))
	if door_police:
		door_police.connect("blocked", Callable(self, "_on_door_blocked"))
	if door_policeBack:
		door_policeBack.connect("blocked", Callable(self, "_on_door_blocked"))
	if door_gangster:
		door_gangster.connect("blocked", Callable(self, "_on_door_blocked"))



func _on_pickup_interacted(interacted_item_name: String):
	if interacted_item_name != glitchy.item_name:
		return 
		
	var dialogue = get_node("Dialogue")
	var hud = get_tree().get_first_node_in_group("playerHUD")
	var dialogue_to_use: Dictionary

	if not SceneManager.glitchy_joe:
		dialogue_to_use = GLITCHY_JOE_FIRST_DIALOGUE
	else:
		dialogue_to_use = GLITCHY_JOE_REPEAT_DIALOGUE
		
	if dialogue and dialogue_to_use:
		dialogue.start_dialogue(dialogue_to_use)
		await dialogue.dialogue_finished

		if not SceneManager.glitchy_joe:
			SceneManager.set_flag("gangster", true)
			if hud:
				hud.update_mission("Go to the Yakuza Tower")
				
				print("Mission updated!")
			
			SceneManager.glitchy_joe = true



func _intro_sequence() -> void:
	var dialogue = get_node("Dialogue")
	var position = get_node("first_startpoint")
	var player = get_node("Player")
	var citymap_intro_dialogue = {
		"npc_name": "Player",
		"dialogue_lines": [
			{"name": "Navi", "text": "Welcome to NeoTokyo. It smells of fried rats and broken dreams.\nMove carefully, Detective."}
		]
	}
	player.global_position = position.global_position
	dialogue.start_dialogue(citymap_intro_dialogue)

func _on_door_blocked():
	var dialogue = get_node("Dialogue")
	dialogue.start_dialogue({
		"npc_name": "Player",
		"dialogue_lines": [{"name": "Player", "text": "I can’t go in there yet."}]
	})
