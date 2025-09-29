extends Node2D

@onready var fade_overlay: ColorRect = $Fading_Out/ColorRect2
@onready var anim_player: AnimationPlayer = $Fading_Out/AnimationPlayer
@onready var door: Door = $LeaveRoom
@onready var keypad = $CanvasLayer2/Control


func _ready():
	if not SceneManager.bedroom_intro_done:
		SceneManager.bedroom_intro_done = true
		_intro_sequence()


	if keypad:
		keypad.connect("code_verified", Callable(self, "_on_keypad_result"))
	if door:
		door.connect("blocked", Callable(self, "_on_door_blocked"))


func _intro_sequence() -> void:
	var player = get_node("Player")
	var bed_marker = get_node("bed")
	var dialogue = get_node("Dialogue_player")

	fade_overlay.visible = true
	player.global_position = bed_marker.global_position
	await get_tree().process_frame

	var bedroom_intro_dialogue = {
		"npc_name": "Player",
		"dialogue_lines": [
			{"name": "Navi", "text": "Good morning, junk-face! Hungover again?\nOh… System check reports: Traumatic event. Brother: dead.\n…Well, that sure brightens the mood."},
			{"name": "Player", "text": "…My brother really is dead?"},
			{"name": "Navi", "text": "Confirmed. And, surprise: 1 new e-mail from your brother.\nCoincidence? I think not.\nBut hey, put some clothes on. Players don’t like naked protagonists."},
			{"name": "Navi", "text": "BTW: The controls are:\nMoving: WASD\nInteract: E\nOr click bottom left on me to open your HUD."}
		]
	}

	player.set_movement_allowed(false)
	dialogue.start_dialogue(bedroom_intro_dialogue)
	await dialogue.dialogue_finished

	fade_overlay.visible = false
	anim_player.play("Fade Out")
	await anim_player.animation_finished


func _on_door_blocked():
	var dialogue = get_node("Dialogue_player")
	dialogue.start_dialogue({
		"npc_name": "Player",
		"dialogue_lines": [{"name": "Player", "text": "I can’t leave yet. I need to check my e-mails"}]
	})


func _on_keypad_result(result: bool):
	var dialogue = get_node("Dialogue_player")
	if result:
		if not SceneManager.get_flag("code_bedroom_seen"):
			SceneManager.set_flag("code_bedroom", true)
			SceneManager.set_flag("code_bedroom_seen", true)
			var hud = get_tree().get_first_node_in_group("playerHUD")
			if hud:
				hud.update_mission("Find Glitchy Joe in Neon Alley")
			dialogue.start_dialogue({
				"npc_name": "Navi",
				"dialogue_lines": [
					{"name": "Navi", "text": "Very nice. Password accepted.\nAn e-mail has been found: LAST_MSG.MP250.\nDo you want to play it?"},
					{"name": "Player", "text": "Play it."},
					{"name": "Brother", "text": "If you're seeing this… it means I'm gone.\nI found something… something bigger than all of us. Something connected to NeoCorp – the company that vanished three years ago."},
					{"name": "Brother", "text": "Look for Glitchy Joe. He's hanging around Neon Alley.\nTell him 'Asahi'. He'll know what it means.\nTake care… kid."},
					{"name": "Player", "text": "Glitchy Joe… Neon Alley."},
					{"name": "Navi", "text": "Objective updated: Glitchy Joe, Neon Alley.\nCoffee optional. Not dying strongly recommended."},
					{"name": "Navi", "text": "Warning: The city is loud. And deadly.\nI’m staying in your head, so at least listen to me occasionally."}
				]
			})
		else:
			dialogue.start_dialogue({
				"npc_name": "Navi",
				"dialogue_lines": [
					{"name": "Navi", "text": "You've already played the message.\nCheck your objective if you need to."}
				]
			})
	else:
		dialogue.start_dialogue({
			"npc_name": "Navi",
			"dialogue_lines": [
				{"name": "Navi", "text": "Wrong code! Try again."}
			]
		})
