extends Node


func _on_start_pressed() -> void:
	$Fading_In/AnimationPlayer.play("Fade In")
	await get_tree().create_timer(6.0).timeout
	var tween := create_tween()
	$Fading_In/Title_Prologue.self_modulate.a = 0.0
	$Fading_In/Title_Prologue.visible = true
	tween.tween_property($Fading_In/Title_Prologue, "self_modulate:a", 1.0, 2.0)
	await tween.finished
	await get_tree().create_timer(2.0).timeout
	var tween_out := create_tween()
	tween_out.tween_property($Fading_In/Title_Prologue, "self_modulate:a", 0.0, 2.0)
	await tween_out.finished
	get_tree().change_scene_to_file("res://Scenes/Prologue/Outside.tscn")

func _on_continue_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
