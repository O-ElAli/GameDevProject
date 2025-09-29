@tool
class_name NPC
extends CharacterBody2D

signal behavior_ready

@export var stealth_enabled: bool = false
@export var data: NPCResource : set = _apply_data
@export var health: int = 100

var current_state: String = "idle"
var facing: Vector2 = Vector2.DOWN
var facing_label: String = "down"
var allow_behavior: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var detection_area: Area2D = $DetectionArea
@onready var col_shape: CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var debug_node: Node2D = $DetectionDebug

func _ready() -> void:
	_initialize_from_resource()
	face_towards(global_position + facing)
	play_animation()

	if Engine.is_editor_hint():
		return

	behavior_ready.emit()

	if detection_area:
		detection_area.body_entered.connect(_on_body_entered_detection)
	if debug_node:
		debug_node.visible = stealth_enabled
		debug_node.col_shape = col_shape

func _physics_process(delta: float) -> void:
	if allow_behavior and velocity != Vector2.ZERO:
		current_state = "walk"
		move_and_slide()
	else:
		velocity = Vector2.ZERO
	play_animation()

func play_animation() -> void:
	if animator:
		animator.play(current_state + "_" + facing_label)

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

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()

func set_behavior_allowed(allowed: bool) -> void:
	allow_behavior = allowed
	if not allowed:
		velocity = Vector2.ZERO
		current_state = "idle"
		if animator:
			animator.play("idle_" + facing_label)

# z. B. direkt beim NPC-Detection-GameOver
func _on_body_entered_detection(body: Node) -> void:
	if stealth_enabled and body.is_in_group("player"):
		print("Spieler entdeckt! Game Over...")
		var player = get_tree().current_scene.get_node("Player")
		SceneManager.enter_scene("res://Scenes/Game Over/GameOver.tscn", player)
