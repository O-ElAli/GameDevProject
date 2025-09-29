extends InteractionArea
class_name Door

@export_file("*.tscn") var target_scene_path := ""
@export var is_exit:= false
@export var required_flag := ""

signal blocked

func interact() -> void:
	if target_scene_path == "":
		print("Empty scene on:", get_path())
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if required_flag != "" and not SceneManager.get_flag(required_flag):
		emit_signal("blocked")
		return
	
	if is_exit:
		SceneManager.go_back(player)
	else:
		SceneManager.enter_scene(target_scene_path, player)
	
