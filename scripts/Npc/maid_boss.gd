extends CharacterBody2D

@export var health: int = 500
@export var general_cooldown: float = 4.0
@export var projectile_speed: float = 350.0
@export var boss_projectile_damage: int = 15


@export var move_speed: float = 50.0
@export var movement_change_time: float = 2.0 


@export var burst_count: int = 5
@export var burst_spread_angle: float = 0.5
@export var burst_delay: float = 0.1

@export var pulse_cooldown: float = 0.8
@export var pulse_total_shots: int = 8
@export var aoe_cooldown: float = 6.0

const AOE_VOID = preload("res://Scenes/NPC/abilities/AoeVoid.tscn")
const PROJECTILE_SCENE = preload("res://Scenes/Player/weapon/projectile/maid_projectile.tscn")

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sprite: Sprite2D = $Sprite2D
@onready var healthbar: ProgressBar = $Healthbar
@onready var damage_number_point: Node2D = $DamageNumberPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $MovementTimer
@onready var pulse_sequence_timer: Timer = $DashTimer
@onready var movement_timer: Timer = Timer.new()

enum BossState { COOLDOWN, BURST_ATTACK, PULSE_ATTACK }
var current_state: BossState = BossState.COOLDOWN
var is_casting_attack: bool = false
var current_look_direction: Vector2 = Vector2.DOWN
var pulse_count: int = 0
var target_move_direction: Vector2 = Vector2.ZERO

func _ready():
	healthbar.value = health
	if sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("active", false)
	
	attack_timer.timeout.connect(_decide_next_attack)
	
	pulse_sequence_timer.one_shot = true
	pulse_sequence_timer.timeout.connect(_execute_pulse_shot)
	
	movement_timer.one_shot = false
	movement_timer.timeout.connect(_calculate_new_target_direction)
	add_child(movement_timer)
	
	_set_state(BossState.COOLDOWN)
	_update_animation(Vector2.ZERO) 
	
	_calculate_new_target_direction()
	movement_timer.start(movement_change_time)


func _physics_process(delta):
	if is_casting_attack:
		velocity = Vector2.ZERO
		movement_timer.stop()
	else:
		velocity = target_move_direction * move_speed
		if movement_timer.is_stopped():
			movement_timer.start(movement_change_time)

	move_and_slide()
	
	if not is_casting_attack:
		_update_animation(velocity)


func _calculate_new_target_direction():
	if not is_instance_valid(player):
		target_move_direction = Vector2.ZERO
		return
		
	var direction_to_player = (player.global_position - global_position).normalized()
	
	var max_erratic_angle = deg_to_rad(10.0)
	var random_offset = randf_range(-max_erratic_angle, max_erratic_angle)
	
	var new_angle = direction_to_player.angle() + random_offset
	target_move_direction = Vector2.from_angle(new_angle).normalized()

func _set_state(new_state: BossState):
	current_state = new_state
	
	match current_state:
		BossState.COOLDOWN:
			is_casting_attack = false
			attack_timer.start(general_cooldown)
			_calculate_new_target_direction() 
			movement_timer.start(movement_change_time) 
		
		BossState.BURST_ATTACK:
			is_casting_attack = true
			movement_timer.stop()
		
		BossState.PULSE_ATTACK:
			is_casting_attack = true
			movement_timer.stop()

func _decide_next_attack():
	if not is_instance_valid(player):
		_set_state(BossState.COOLDOWN)
		return
		
	var next_attack = randi() % 3
	
	if next_attack == 0:
		_start_burst_attack()
	elif next_attack == 1:
		_start_pulse_attack()
	else:
		_start_aoe_attack()


func _start_burst_attack():
	_set_state(BossState.BURST_ATTACK)
	
	var direction_to_player = (player.global_position - global_position).normalized()
	_update_animation(direction_to_player, true)
	
	_execute_burst_sequence(direction_to_player)

func _execute_burst_sequence(base_direction: Vector2):
	await get_tree().create_timer(0.3).timeout
	
	var half_spread = burst_spread_angle / 2.0
	
	var start_angle = base_direction.angle() - half_spread
	var angle_step = burst_spread_angle / float(burst_count - 1)
	
	for i in range(burst_count):
		var current_angle = start_angle + angle_step * i
		var shoot_direction = Vector2.from_angle(current_angle)
		
		_shoot_projectile(shoot_direction)
		
		await get_tree().create_timer(burst_delay).timeout

	_end_attack()


func _start_pulse_attack():
	_set_state(BossState.PULSE_ATTACK)
	pulse_count = 0
	
	var direction_to_player = (player.global_position - global_position).normalized()
	_update_animation(direction_to_player, true)
	
	await get_tree().create_timer(0.5).timeout
	
	pulse_sequence_timer.start(0.0)

func _execute_pulse_shot():
	if pulse_count >= pulse_total_shots:
		_end_attack()
		return

	var directions: Array[Vector2] = []

	if pulse_count % 2 == 0:
		directions.append_array([Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT])
		
	else:
		directions.append_array([
			Vector2(-1, -1).normalized(), 
			Vector2(1, -1).normalized(), 
			Vector2(-1, 1).normalized(), 
			Vector2(1, 1).normalized()  
		])

	for dir in directions:
		_shoot_projectile(dir)
		
	pulse_count += 1
	
	pulse_sequence_timer.start(pulse_cooldown)
	

func _start_aoe_attack():
	_set_state(BossState.COOLDOWN)
	
	var aoe_instance = AOE_VOID.instantiate()
	get_parent().add_child(aoe_instance)
	
	if is_instance_valid(player):
		aoe_instance.global_position = player.global_position
	else:
		aoe_instance.global_position = global_position

	_end_attack()

func _end_attack():
	_set_state(BossState.COOLDOWN)



func _shoot_projectile(direction: Vector2):
	var projectile_instance = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile_instance)
	
	projectile_instance.global_position = global_position
	
	if projectile_instance.has_method("set_projectile_data"):
		projectile_instance.set_projectile_data(
			boss_projectile_damage, 
			projectile_speed, 
			direction
		)


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
		get_tree().change_scene_to_file("res://Scenes/Map/Underground/villain_room.tscn")
