extends Node2D

@onready var keypad = $CanvasLayer2/Control
@onready var player = $Player
@onready var dialogue = $Dialogue_player
@onready var teleport_marker = $entry
@onready var start_marker = $start_marker
@onready var usb = $USB
var _usb_dialogue_played = false

func _ready():
	player.global_position = start_marker.global_position
	if not SceneManager.police_right_intro_done:
		SceneManager.police_right_intro_done = true
		_intro_sequence()
	if keypad:
		keypad.connect("code_verified", Callable(self, "_on_keypad_result"))

func _process(_delta: float) -> void:
	if not SceneManager.usb_mission_done:
		if not usb or not usb.is_inside_tree():
			var hud = get_tree().get_first_node_in_group("playerHUD")
			var dialogue = get_node("Dialogue")
			SceneManager.set_flag("bar", true)
			if hud:
				hud.update_mission("USB acquired! Find Clyde")
				print("Mission updated!")
			SceneManager.usb_mission_done = true


func _intro_sequence() -> void:
	player.set_movement_allowed(false)

	var police_intro_dialogue = {
		"npc_name": "Player",
		"dialogue_lines": [
			{"name": "Navi", "text": "Be careful that nobody catches you, otherwise we're screwed."},
		]
	}

	dialogue.start_dialogue(police_intro_dialogue)
	await dialogue.dialogue_finished
	player.set_movement_allowed(true)

func _on_keypad_result(result: bool):
	if result:
		player.global_position = teleport_marker.global_position
		
		SceneManager.set_flag("police_right_code_used", true)

		dialogue.start_dialogue({
			"npc_name": "Navi",
			"dialogue_lines": [
				{"name": "Navi", "text": "Code accepted. You’ve been safely moved to the next area. Stay sharp!"}
			]
		})
	else:
		dialogue.start_dialogue({
			"npc_name": "Navi",
			"dialogue_lines": [
				{"name": "Navi", "text": "Wrong code! Try again."}
			]
		})
