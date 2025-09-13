extends Area2D

var entered

func _on_body_entered(body: Node2D) -> void:
	entered = true


func _on_body_exited(body: Node2D) -> void:
	entered = false


func _process(delta):
	if entered:
		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene_to_file("res://Scenes/maidcafe/maidcafe.tscn")
