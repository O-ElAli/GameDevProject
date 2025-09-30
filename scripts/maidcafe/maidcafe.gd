extends Node2D

@onready var note = $note
@onready var fade_overlay: ColorRect = $Fading_Out/ColorRect2
@onready var anim_player: AnimationPlayer = $Fading_Out/AnimationPlayer


const NOTE_FIRST_DIALOGUE = {
	"npc_name": "Note",
	"dialogue_lines": [
		{"name": "Player", "text": "This must be the note the maid mentioned…"},
		{"name": "Note", "text": "Detective,\nIf you are reading this, I’m already gone. NeoCorp’s men are on my trail. I can’t risk staying any longer."},
		{"name": "Note", "text": "I have an informant who knows the entrance to NeoCorp’s hideout, but they’ve been arrested by the police. Their names are Bonnie and Clyde. Go question them. Over and out.\n—V10-La"},
		{"name": "Navi", "text": "Bonnie and Clyde, huh? Great… just don’t ask them for driving lessons!"}
	]
}

const NOTE_REPEAT_DIALOGUE = {
	"npc_name": "Note",
	"dialogue_lines": [
		{"name": "Player", "text": "It’s just the same note."}
	]
}

func _ready():
	if not SceneManager.maid_intro_done:
		SceneManager.maid_intro_done = true
		_intro_sequence()
	if note and note is Pickup:
		note.connect("interaction_finished", Callable(self, "_on_note_interacted"))


func _on_note_interacted(interacted_item_name: String) -> void:
	if interacted_item_name != note.item_name:
		return

	var dialogue = get_node("Dialogue")
	var hud = get_tree().get_first_node_in_group("playerHUD")
	var dialogue_to_use: Dictionary

	if not SceneManager.note:
		dialogue_to_use = NOTE_FIRST_DIALOGUE
		SceneManager.set_flag("note", true)
		SceneManager.set_flag("police", true)
		SceneManager.note = true
		if hud:
			hud.update_mission("Go to the Police Station and talk with Bonnie and Clyde")
	else:
		dialogue_to_use = NOTE_REPEAT_DIALOGUE

	if dialogue and dialogue_to_use:
		dialogue.start_dialogue(dialogue_to_use)
		await dialogue.dialogue_finished
		if dialogue_to_use == NOTE_FIRST_DIALOGUE:
			await _play_chapter_transition()

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


	anim_player.play("Fade Out")
	await anim_player.animation_finished

	fade_overlay.visible = false
	player.set_movement_allowed(true)




func _intro_sequence() -> void:
	var player = get_node("Player")
	var dialogue = get_node("Dialogue")

	var maid_intro_dialogue = {
	"npc_name": "Maid",
	"dialogue_lines": [
		{"name": "Akira", "text": "Hello, Master. What would you like today?"},
		{"name": "Player", "text": "I heard one of the maids has gone missing recently."},
		{"name": "Akira", "text": "Ah, you must mean V10-La. Yes, she’s been missing since yesterday. She told me that if the detective showed up, I should tell him she left a note at the usual place."},
		{"name": "Player", "text": "Where is the note?"},
		{"name": "Akira", "text": "I’m afraid that’s all I can say… but how about a coffee, Master?"}
	]
}
	player.set_movement_allowed(false)
	dialogue.start_dialogue(maid_intro_dialogue)
	await dialogue.dialogue_finished
