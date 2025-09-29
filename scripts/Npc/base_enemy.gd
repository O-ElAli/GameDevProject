extends CharacterBody2D

@export var health: int = 500
@export var shoot_cooldown: float = 3.0
@export var boss_projectile_damage: int = 15
@export var projectile_speed: float = 500.0
@export var move_speed: float = 150.0

const PROJECTILE_SCENE = preload("res://Scenes/Player/weapon/projectile/maid_projectile.tscn")
@onready var katana: AnimationPlayer = $"../Katana/Katanamove"

@onready var sprite: Sprite2D = $Sprite2D
@onready var healthbar: ProgressBar = $Healthbar
@onready var damage_number_point: Node2D = $DamageNumberPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_timer: Timer = $MovementTimer
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")


var current_look_direction: Vector2 = Vector2.DOWN
var is_casting_attack: bool = false


func _ready():
	healthbar.value = health
	
	if sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("active", false)
	
	shoot_timer.timeout.connect(_shoot_at_player)
	shoot_timer.start(shoot_cooldown)
	
	_update_animation(Vector2.ZERO)


func _physics_process(delta):
	velocity = Vector2.ZERO
	
	move_and_slide()
	
	if not is_casting_attack:
		_update_animation(velocity)


func _shoot_at_player():
	if not is_instance_valid(player):
		shoot_timer.start(shoot_cooldown)
		return

	is_casting_attack = true
	shoot_timer.stop()
	
	var shoot_direction = (player.global_position - global_position).normalized()
	_update_animation(shoot_direction, true)
	
	await get_tree().create_timer(0.3).timeout
	
	katana.play("swing_180")
	var projectile_instance = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile_instance)
	
	projectile_instance.global_position = global_position
	
	if projectile_instance.has_method("set_projectile_data"):
		projectile_instance.set_projectile_data(
			boss_projectile_damage,
			projectile_speed,
			shoot_direction
		)

	is_casting_attack = false
	shoot_timer.start(shoot_cooldown)


func _update_animation(current_velocity: Vector2, is_casting: bool = false):
	var new_animation: String = ""
	var is_moving = current_velocity.length_squared() > 0.01

	if is_moving or is_casting:
		current_look_direction = current_velocity
	
	var direction_x = current_look_direction.x
	var direction_y = current_look_direction.y
	
	if abs(direction_x) > abs(direction_y):
		new_animation = "side"
		sprite.flip_h = direction_x < 0
	elif direction_y > 0:
		new_animation = "down"
		sprite.flip_h = false
	else:
		new_animation = "up"
		sprite.flip_h = false

	if is_moving:
		new_animation = "walk_" + new_animation
	else:
		new_animation = "idle_" + new_animation

	if animation_player.current_animation != new_animation:
		animation_player.play(new_animation)
		

func damage_flash():
	if sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("active", true)
		var timer = get_tree().create_timer(0.1)
		timer.timeout.connect(func():
			sprite.material.set_shader_parameter("active", false)
			)

func take_damage(amount: int):
	health -= amount
	DamageNumber.display_damage(amount, damage_number_point.global_position)
	healthbar.value = health
	damage_flash()
	print("Gegner hat " + str(health) + " Lebenspunkte übrig.")
	
	if health <= 0:
		queue_free()
