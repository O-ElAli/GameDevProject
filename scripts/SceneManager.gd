extends Node


var scene_stack = []
var scene_data = {}

func enter_scene(new_scene_path: String, player: CharacterBody2D) -> void:
	var current_scene = get_tree().current_scene.scene_file_path
	
	#Save current scene state before leaving
	if player and current_scene:
		scene_data[current_scene] = {
			"player_position": player.global_position,
			"timestamp": Time.get_unix_time_from_system()
		}
	
	# Push current scene to stack
	if current_scene != "":
		scene_stack.push_back(current_scene)
	
	get_tree().change_scene_to_file(new_scene_path)

func go_back(player: CharacterBody2D):
	if scene_stack.size > 0:
		var previous_scene = scene_stack.pop_back()
		get_tree().change_scene_to_file(previous_scene)
	
	else:
		# Fallback to main scene
		get_tree().change_scene_to_file("res://Scenes/Map/citymap.tscn")
	

func restore_player_position(player: CharacterBody2D, scene_path: String):
	if scene_path in scene_data:
		player.global_position = scene_data[scene_path]["player_position"]
		print("Restored position for: ", scene_path)

func clear_stack():
	scene_stack.clear()
