extends Node2D
@onready var fade_overlay: ColorRect = $Fading_Out/ColorRect2
@onready var anim_player: AnimationPlayer = $Fading_Out/AnimationPlayer
@onready var end_pc = $end_pc

func _ready():
	if not SceneManager.last_intro_done:
		SceneManager.last_intro_done = true
		_intro_sequence()
	if end_pc and end_pc is Pickup:
		end_pc.connect("interaction_finished", Callable(self, "_on_pc_interacted"))

func _on_pc_interacted(interacted_item_name: String) -> void:
	if interacted_item_name != end_pc.item_name:
		return

	var dialogue = get_node("Dialogue")
	var dialogue_to_use: Dictionary

	if not SceneManager.end_pc:
		SceneManager.set_flag("end_pc", true)
		SceneManager.end_pc = true
		_play_chapter_transition()
	else:
		pass

func _play_chapter_transition() -> void:
	var player = get_node("Player")
	player.set_movement_allowed(false)

	fade_overlay.visible = true


	anim_player.play("Fade In")
	await anim_player.animation_finished


	var title = $Fading_Out/Title_Prologue
	var tween := create_tween()
	title.self_modulate.a = 0.0
	title.visible = true

	tween.tween_property(title, "self_modulate:a", 1.0, 2.0)
	await tween.finished


	await get_tree().create_timer(2.0).timeout


	var tween_out := create_tween()
	tween_out.tween_property(title, "self_modulate:a", 0.0, 2.0)
	await tween_out.finished
	title.visible = false
	fade_overlay.visible = false
	player.set_movement_allowed(true)
	get_tree().change_scene_to_file("res://Scenes/Start_Screen/start_screen.tscn")


func _intro_sequence() -> void:
	var player = get_node("Player")
	var dialogue = get_node("Dialogue")

	var last_intro_dialogue = {
		"npc_name": "Morrick",
		"dialogue_lines": [
			{"name": "Morrick", "text": "Well, well the little brother shows up. Want revenge? How sweet. Your brother already failed, you will too."},
			{"name": "Player", "text": "Fuck you. I'll kill you."},
			{"name": "Morrick", "text": "Not so fast. Remember V10-La? I reprogrammed her. V10-La eliminate him."},
			{"name": "Navi", "text": "Kick his ass!"}
		]
	}

	player.set_movement_allowed(false)
	dialogue.start_dialogue(last_intro_dialogue)
	await dialogue.dialogue_finished
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scenes/Map/Underground/villain_room_fighting.tscn")
