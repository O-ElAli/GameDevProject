extends Node2D


@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

const base_text := "[E] to "

var active_areas : Array[InteractionArea] = []
var can_interact := true

func register_area(area: InteractionArea):
	# Add the area2d in which the player is standing
	print("Regiser", area, "count:", active_areas.size()+1)
	active_areas.append(area)

func unregister_area(area: InteractionArea):
	# Remove the area2d that the player left
	var index = active_areas.find(area)
	if index != -1:
		active_areas.pop_at(index)

func _process(_delta):
	# If array not empty and can_interact is true sort which one is closer to the player
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 30
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		print("interact pressed")
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
