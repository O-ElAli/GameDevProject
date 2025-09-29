extends Area2D

@export var base_damage: int = 10
@export var base_speed: float = 500.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var current_damage: int = 0
var current_speed: float = 0.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	current_damage = base_damage
	current_speed = base_speed

	if direction == Vector2.ZERO:
		direction = Vector2.DOWN.normalized()
	animated_sprite_2d.play("ball")

func set_projectile_data(damage_amount: int, speed: float, launch_direction: Vector2):
	current_damage = damage_amount
	current_speed = speed
	direction = launch_direction.normalized()

func _process(delta: float) -> void:
	position += direction * current_speed * delta

func _on_body_entered(body):
	if body is CharacterBody2D and body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(current_damage)
			
		queue_free()
			
func _on_visibility_notifier_2d_screen_exited():
	queue_free()
