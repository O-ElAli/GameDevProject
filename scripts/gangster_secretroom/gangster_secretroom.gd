extends Node2D

@onready var moderator = $moderator


const MODERATOR_FIRST_DIALOGUE = {
	"npc_name": "Moderator",
	"dialogue_lines": [
		{"name": "Moderator", "text": "You want to become the champion?"},
		{"name": "Player", "text": "Then I’m ready!"},
		{"name": "Moderator", "text": "I’m curious to see how you’ll do. Let’s go to the rumble!"},
		{"name": "Navi", "text": "Here we go, Player! Time to show your skills!"},
		{"name": "Navi", "text": "Switch Weapons = 1,2, Shooting = Left Click one the mouse"}
	]
}

const MODERATOR_REPEAT_DIALOGUE = {
	"npc_name": "Moderator",
	"dialogue_lines": [
		{"name": "Moderator", "text": "Oh, the champion is back! So far, you have no opponent. You can also go to the boss anytime now that you are the champion."},
		
	]
}



func _ready():
	if moderator and moderator is Pickup:
		moderator.connect("interaction_finished", Callable(self, "_on_moderator_interacted"))


func _on_moderator_interacted(interacted_item_name: String) -> void: 
	if interacted_item_name != moderator.item_name:
		return

	var dialogue = get_node("Dialogue")
	var hud = get_tree().get_first_node_in_group("playerHUD")
	var dialogue_to_use: Dictionary

	if not SceneManager.moderator:
		dialogue_to_use = MODERATOR_FIRST_DIALOGUE
		SceneManager.set_flag("moderator", true)
		SceneManager.set_flag("boss_room", true)
		SceneManager.moderator = true
		if hud:
			hud.update_mission("You are the Champion, go to the Boss")
	else:
		dialogue_to_use = MODERATOR_REPEAT_DIALOGUE

	if dialogue and dialogue_to_use:
		dialogue.start_dialogue(dialogue_to_use)
		await dialogue.dialogue_finished

		# Szenewechsel nur beim ersten Mal
		if dialogue_to_use == MODERATOR_FIRST_DIALOGUE:
			await get_tree().process_frame
			get_tree().change_scene_to_file("res://Scenes/Map/Gangster/gangster_secretroom_fighting.tscn")
