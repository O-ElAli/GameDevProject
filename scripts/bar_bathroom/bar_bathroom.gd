extends Node2D

@onready var clyde = $clyde
@onready var fade_overlay: ColorRect = $Fading_Out/ColorRect2
@onready var anim_player: AnimationPlayer = $Fading_Out/AnimationPlayer


const CLYDE_FIRST_DIALOGUE = {
	"npc_name": "Clyde",
	"dialogue_lines": [
		{"name": "Player", "text": "Clyde… are you in there?"},
		{"name": "Clyde", "text": "Who’s asking? *hic*… oh, Bonnie sent ya, right? She said you need the USB decrypted."},
		{"name": "Clyde", "text": "gimme that thing… *slurs*… alright, done! Kick NeoCorp’s ass!"},
		{"name": "Player", "text": "Thanks, man."},
		{"name": "Navi", "text": "Ok, now we know where NeoCorp is. Time for revenge! Let’s tell the Yakuza, they promised to help once we locate them."},
		{"name": "Player", "text": "Got it… finally, I can get my revenge."}
	]
}

const CLYDE_REPEAT_DIALOGUE = {
	"npc_name": "Clyde",
	"dialogue_lines": [
		{"name": "Clyde", "text": "…Yeah yeah, you already know. Nothing new here."} # Placeholder
	]
}

func _ready():
	if clyde and clyde is Pickup:
		clyde.connect("interaction_finished", Callable(self, "_on_clyde_interacted"))

func _on_clyde_interacted(interacted_item_name: String) -> void:
	if interacted_item_name != clyde.item_name:
		return

	var dialogue = get_node("Dialogue")
	var hud = get_tree().get_first_node_in_group("playerHUD")
	var dialogue_to_use: Dictionary

	if not SceneManager.clyde:
		dialogue_to_use = CLYDE_FIRST_DIALOGUE
		SceneManager.set_flag("clyde", true)
		SceneManager.clyde = true
		if hud:
			hud.update_mission("Fight NeoCorp")
	else:
		dialogue_to_use = CLYDE_REPEAT_DIALOGUE

	if dialogue and dialogue_to_use:
		dialogue.start_dialogue(dialogue_to_use)
		await dialogue.dialogue_finished
		if dialogue_to_use == CLYDE_FIRST_DIALOGUE:
			await _play_chapter_transition("Chapter 3: Nocturne") 


func _play_chapter_transition(chapter_title: String) -> void:
	var player = get_node("Player")
	player.set_movement_allowed(false)

	fade_overlay.visible = true


	anim_player.play("Fade In")
	await anim_player.animation_finished


	var title = $Fading_Out/Title_Prologue
	var tween := create_tween()
	title.self_modulate.a = 0.0
	title.visible = true
	title.text = chapter_title

	tween.tween_property(title, "self_modulate:a", 1.0, 2.0)
	await tween.finished


	await get_tree().create_timer(2.0).timeout

	get_tree().change_scene_to_file("res://Scenes/Map/Underground/underground_main.tscn")
