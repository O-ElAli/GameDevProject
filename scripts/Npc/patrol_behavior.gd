@tool
extends NPCBehavior

const COLORS := [Color.RED, Color.YELLOW, Color.GREEN,Color.CYAN, Color.BLUE, Color.MAGENTA]

@export var speed: float = 30.0

var waypoints: Array[PatrolLocation] = []
var index: int = 0
var active_target: PatrolLocation

var was_interrupted: bool = false
var pre_interrupt_velocity: Vector2 = Vector2.ZERO
var pre_interrupt_state: String = "idle"

func _ready() -> void:
	_collect_waypoints()
	if Engine.is_editor_hint():
		child_entered_tree.connect(_collect_waypoints)
		child_order_changed.connect(_collect_waypoints)
		return
	super._ready()
	if waypoints.is_empty():
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	active_target = waypoints[0]

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var dialogue_system = get_tree().get_first_node_in_group("dialogue_system")
	if dialogue_system and dialogue_system.is_active:
		# PAUSE: Save current state when dialogue starts
		if not was_interrupted:
			pre_interrupt_velocity = npc.velocity
			pre_interrupt_state = npc.current_state
			was_interrupted = true
		
		# Freeze during dialogue
		npc.velocity = Vector2.ZERO
		npc.current_state = "idle"
		npc.play_animation()
		return
	
	# RESUME: Restore state when dialogue ends
	if was_interrupted:
		was_interrupted = false
		npc.velocity = pre_interrupt_velocity
		npc.current_state = pre_interrupt_state
		npc.play_animation()
		return
	
	# Normal patrol logic
	var threshold := 4.0
	if npc.global_position.distance_to(active_target.target_position) <= threshold:
		npc.global_position = active_target.target_position
		npc.velocity = Vector2.ZERO
		_start_next_segment()

func _collect_waypoints(_n: Node = null) -> void:
	waypoints.clear()
	for child in get_children():
		if child is PatrolLocation:
			waypoints.append(child)

	# Editor-only Darstellung
	if Engine.is_editor_hint() and not waypoints.is_empty():
		for i in range(waypoints.size()):
			var wp := waypoints[i] as PatrolLocation
			if not wp.tranform_changed.is_connected(_collect_waypoints):
				wp.tranform_changed.connect(_collect_waypoints)
			wp.update_label(str(i))                    # Zahl aktualisieren
			wp.modulate = _color_for_index(i)          # Farbe zuweisen
			var nxt := waypoints[(i + 1) % waypoints.size()]
			wp.update_line(nxt.position)

func _start_next_segment() -> void:
	# Skip if dialogue is active
	var dialogue_system = get_tree().get_first_node_in_group("dialogue_system")
	if dialogue_system and dialogue_system.is_active:
		return
	
	if not npc.allow_behavior or waypoints.size() < 2:
		return

	# Idle-Phase
	npc.current_state = "idle"
	npc.velocity = Vector2.ZERO
	npc.play_animation()

	var wait := active_target.wait_time
	index = (index + 1) % waypoints.size()
	active_target = waypoints[index]

	await get_tree().create_timer(wait).timeout
	
	# Check again after waiting
	dialogue_system = get_tree().get_first_node_in_group("dialogue_system")
	if not npc.allow_behavior or (dialogue_system and dialogue_system.is_active):
		return

	# Bewegungs-Phase
	npc.current_state = "walk"
	var dir := global_position.direction_to(active_target.target_position)
	npc.facing = dir
	npc.velocity = dir * speed
	npc.face_towards(active_target.target_position)
	npc.play_animation()

func _color_for_index(i: int) -> Color:
	return COLORS[i % COLORS.size()]
