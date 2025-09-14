extends InteractionArea
class_name Door

@export var target_scene : PackedScene

func interact() -> void:
	if target_scene == null:
		print("Empty scene on:", get_path())
		return
	print("Changing to:", target_scene.resource_path)
	get_tree().change_scene_to_packed(target_scene)
