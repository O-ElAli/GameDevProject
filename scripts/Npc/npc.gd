@tool
class_name NPC extends CharacterBody2D

signal behavior_ready

var current_state: String = "idle"
var facing: Vector2 = Vector2.DOWN
var facing_label: String = "down"
var allow_behavior: bool = true

@export var npc_name: String = "NPC"
var lines_dict = {
	"Igor": [
		'Hello, I\'m Igor!',
		'Nice to meet you!'
	]
}

var dialogue_lines: Array = []

@export var data: NPCResource : set = _apply_data

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if lines_dict.has(npc_name):
		print("if")
		dialogue_lines = lines_dict[npc_name]
	else:
		print("else")
		dialogue_lines = []
	_initialize_from_resource()
	face_towards(global_position + facing)
	play_animation()
	if Engine.is_editor_hint():
		return
	behavior_ready.emit()

func _physics_process(delta: float) -> void:
	move_and_slide()

func play_animation() -> void:
	if animator:
		animator.play(current_state + "_" + facing_label)
	else:
		if Engine.is_editor_hint():
			return
	

func face_towards(target: Vector2) -> void:
	facing = global_position.direction_to(target)
	_resolve_facing_label()
	if sprite:
		sprite.flip_h = facing_label == "side" and facing.x < 0

func _resolve_facing_label() -> void:
	var limit := 0.45
	if facing.y < -limit:
		facing_label = "up"
	elif facing.y > limit:
		facing_label = "down"
	elif abs(facing.x) > limit:
		facing_label = "side"

func _initialize_from_resource() -> void:
	if data and sprite:
		sprite.texture = data.sprite

func _apply_data(new_data: NPCResource) -> void:
	data = new_data
	_initialize_from_resource()
