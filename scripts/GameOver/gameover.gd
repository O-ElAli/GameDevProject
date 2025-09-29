extends CanvasLayer



func _on_button_pressed() -> void:
	queue_free()
	var player = get_tree().current_scene.get_node("Player")
	SceneManager.go_back(player)
