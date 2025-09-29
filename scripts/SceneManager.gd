extends Node

var bedroom_intro_done := false
var maid_intro_done := false
var citymap_intro_done := false
var police_right_intro_done := false
var bar_main_intro_done := false
var last_intro_done := false
var scene_stack = []
var scene_data = {}
var current_mission_text := ""
var usb_mission_done := false
var glitchy_joe := false
var warden := false
var moderator := false
var boss := false
var note := false
var end_pc := false
var bonnie := false
var clyde :=false
var silverarm := false
var items_held : Array = []

var flags: Dictionary = {
	"code_bedroom": false,
	"code_bedroom_seen":false,
	"code_police_seen":false,
	"maid": false,
	"bar": false,
	"police": false,
	"police_back": false,
	"gangster": false,
	"basement": false,
	"boss_room": false,
	"police_top": false
}

var loading_screen_scene := preload("res://Scenes/loading_screen/LoadingScreen.tscn")
var next_scene_path: String = ""
var loading_screen_instance: Node = null
var loading_in_progress: bool = false

func set_flag(flag_name: String, value: bool = true) -> void:
	flags[flag_name] = value

func get_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)


func enter_scene(new_scene_path: String, player: CharacterBody2D) -> void:
	var current_scene = get_tree().current_scene.scene_file_path
	
	if player and current_scene:
		scene_data[current_scene] = {
			"player_position": player.global_position,
			"timestamp": Time.get_unix_time_from_system()
		}
	
	if current_scene != "":
		scene_stack.push_back(current_scene)
	
	_show_loading_screen(new_scene_path)

func _show_loading_screen(scene_path: String) -> void:
	next_scene_path = scene_path
	loading_screen_instance = loading_screen_scene.instantiate()
	get_tree().root.add_child(loading_screen_instance)

	ResourceLoader.load_threaded_request(scene_path)
	loading_in_progress = true
	set_process(true)

func _process(_delta: float) -> void:
	if loading_in_progress:
		var progress: Array = []
		var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
		
		if loading_screen_instance and loading_screen_instance.has_node("ProgressBar"):
			loading_screen_instance.get_node("ProgressBar").value = int(progress[0] * 100.0)
		
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				pass
			ResourceLoader.THREAD_LOAD_FAILED:
				push_error("Fehler beim Laden von %s" % next_scene_path)
				loading_in_progress = false
				set_process(false)
			ResourceLoader.THREAD_LOAD_LOADED:
				var new_scene = ResourceLoader.load_threaded_get(next_scene_path)
				get_tree().change_scene_to_packed(new_scene)
				
				if loading_screen_instance:
					loading_screen_instance.queue_free()
					loading_screen_instance = null
				
				loading_in_progress = false
				set_process(false)

func go_back(player: CharacterBody2D):
	if scene_stack.size() > 0:
		var previous_scene = scene_stack.pop_back()
		_show_loading_screen(previous_scene)
	else:
		_show_loading_screen("res://Scenes/Map/citymap.tscn")

func restore_player_position(player: CharacterBody2D, scene_path: String):
	if scene_path in scene_data:
		player.global_position = scene_data[scene_path]["player_position"]
		print("Restored position for: ", scene_path)

func clear_stack():
	scene_stack.clear()
