extends Node2D

@export var speed: float = 300.0
@export var talk_range: float = 50.0
@export var dialog_system_path: NodePath 

var direction: Vector2 = Vector2.ZERO
var active_npc = null

@onready var npcs := get_tree().get_nodes_in_group("npc")
@onready var sprite: AnimatedSprite2D = $sprite
@onready var dialog_system = null

func _ready() -> void:
	if dialog_system_path and dialog_system_path != NodePath(""):
		dialog_system = get_node(dialog_system_path)
	if not dialog_system:
		push_warning("Player: dialog_system_path nicht gesetzt – weise im Inspector die DialogSystem-Node zu.")

func _process(delta: float) -> void:
	_check_for_npc_interaction()

	if dialog_system and dialog_system.is_active:
		direction = Vector2.ZERO
	else:
		direction = Vector2(
			int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
			int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		)

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		position += direction * speed * delta

		
		if direction.x > 0:
			sprite.animation = "Right"
		elif direction.x < 0:
			sprite.animation = "Left"
		elif direction.y > 0:
			sprite.animation = "Down"
		elif direction.y < 0:
			sprite.animation = "Up"
	else:
		if sprite.animation != "Idle":
			sprite.animation = "Idle"

func _input(event) -> void:
	if event.is_action_pressed("dialogue_interaction"):
		if active_npc and dialog_system and not dialog_system.is_active:
			dialog_system.start_dialog(active_npc)
		elif dialog_system and dialog_system.is_active:
			
			dialog_system._show_next_line()


func _check_for_npc_interaction() -> void:
	active_npc = null
	for npc in npcs:
		if global_position.distance_to(npc.global_position) <= talk_range:
			active_npc = npc
			break
