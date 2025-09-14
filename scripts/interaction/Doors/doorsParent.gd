extends InteractionArea
class_name Door

@export_file("*.tscn") var target_scene_path := ""

func interact() -> void:
	if target_scene_path == null:
		print("Empty scene on:", get_path())
		return

	get_tree().change_scene_to_file(target_scene_path)
