@tool
extends NPCBehavior

const COLORS := [Color.RED, Color.YELLOW, Color.GREEN, Color.CYAN, Color.BLUE, Color.MAGENTA]

@export var speed: float = 30.0

var waypoints: Array[PatrolLocation] = []
var index: int = 0
var active_target: PatrolLocation
var _waiting: bool = false   

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
	_start_next_segment()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() or not npc.allow_behavior or not active_target:
		return
	if _waiting:
		return

	
	var dir := npc.global_position.direction_to(active_target.target_position)
	npc.velocity = dir * speed

	
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

	
	if Engine.is_editor_hint() and not waypoints.is_empty():
		for i in range(waypoints.size()):
			var wp := waypoints[i] as PatrolLocation
			if not wp.transform_changed.is_connected(_collect_waypoints):
				wp.transform_changed.connect(_collect_waypoints)
			wp.update_label(str(i))                    # Zahl aktualisieren
			wp.modulate = _color_for_index(i)          # Farbe zuweisen
			var nxt := waypoints[(i + 1) % waypoints.size()]
			wp.update_line(nxt.position)

func _start_next_segment() -> void:
	if not npc.allow_behavior or waypoints.size() < 2:
		return

	
	npc.current_state = "idle"
	npc.velocity = Vector2.ZERO
	npc.play_animation()

	var wait := active_target.wait_time
	index = (index + 1) % waypoints.size()
	active_target = waypoints[index]

	if wait > 0:
		_waiting = true
		await get_tree().create_timer(wait).timeout
		_waiting = false
	if not npc.allow_behavior:
		return

	
	npc.current_state = "walk"
	npc.facing = npc.global_position.direction_to(active_target.target_position)
	npc.face_towards(active_target.target_position)
	npc.play_animation()

func _color_for_index(i: int) -> Color:
	return COLORS[i % COLORS.size()]
