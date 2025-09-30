extends CharacterBody2D

@export var health: int = 100
@export var dash_speed: float = 1800.0
@export var dash_cooldown: float = 5.0
@export var dash_anticipation_time: float = 1.5
@export var move_speed: float = 150.0
@export var jitter_change_time: float = 0.5
@export var jitter_max_angle: float = 30.0

@export var dash_damage: int = 25 

@export var projectile_cooldown: float = 3.0
@export var projectile_count: int = 36
@export var projectile_random_spread: float = 5.0 

const PROJECTILE = preload("res://Scenes/Player/weapon/projectile/yakuza_projectile.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var healthbar: ProgressBar = $Healthbar
@onready var damage_number_point: Node2D = $DamageNumberPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var movement_timer: Timer = $MovementTimer
@onready var dash_timer: Timer = $DashTimer
@onready var dash_indicator: Line2D = $DashIndicator

var projectile_timer: Timer = Timer.new()

var current_look_direction: Vector2 = Vector2.DOWN
var dash_direction: Vector2 = Vector2.ZERO
var is_dashing: bool = false
var is_dashing_imminent: bool = false
var target_velocity: Vector2 = Vector2.ZERO
var is_shooting: bool = false
var movement_change_timer: Timer
var jitter_move_direction: Vector2 = Vector2.ZERO

func _ready():
	healthbar.value = health
	
	if sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("active", false)
	
	movement_timer.timeout.connect(_start_dash_anticipation)
	movement_timer.start(dash_cooldown)
	
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_execute_dash)
	
	# indicator erstmal ausblenden
	dash_indicator.visible = false

	projectile_timer.name = "ProjectileTimer"
	add_child(projectile_timer)
	projectile_timer.timeout.connect(_shoot_full_circle)
	projectile_timer.start(projectile_cooldown)
	
	movement_change_timer = Timer.new()
	movement_change_timer.one_shot = false
	movement_change_timer.timeout.connect(_calculate_new_jitter_movement)
	add_child(movement_change_timer)
	
	_update_animation(Vector2.ZERO)
	
	movement_change_timer.start(jitter_change_time)

func _physics_process(delta):
	if is_dashing:
		velocity = dash_direction * dash_speed
	elif is_dashing_imminent or is_shooting:
		velocity = Vector2.ZERO
		_update_animation(dash_direction, true)
	else:
		velocity = jitter_move_direction * move_speed
		if movement_change_timer.is_stopped():
			movement_change_timer.start(jitter_change_time)
	
	var collision = move_and_slide()
	
	if is_dashing and collision:
		for i in range(get_slide_collision_count()):
			var hit = get_slide_collision(i)
			# check ob collided object ein player ist
			if hit.get_collider() and hit.get_collider().is_in_group("player"):
				var player = hit.get_collider()
				if player.has_method("take_damage"):
					player.take_damage(dash_damage)
				_end_dash() 
				return
		_end_dash()
		
	if not is_dashing_imminent and not is_shooting:
		_update_animation(velocity)
		

func _shoot_full_circle():
	is_shooting = true
	
	var projectile_damage: int = 20
	var projectile_speed: float = 450.0

	var angle_step: float = TAU / projectile_count
	var max_spread_rad: float = deg_to_rad(projectile_random_spread)
	
	for i in range(projectile_count):
		var random_offset = randf_range(-max_spread_rad, max_spread_rad)
		var base_angle = i * angle_step
		var current_angle = base_angle + random_offset
		var shoot_direction = Vector2.RIGHT.rotated(current_angle)

		var projectile_instance = PROJECTILE.instantiate()
		
		get_tree().root.add_child(projectile_instance)
		
		projectile_instance.global_position = global_position + shoot_direction * 50
		
		if projectile_instance.has_method("set_projectile_data"):
			projectile_instance.set_projectile_data(
				projectile_damage,
				projectile_speed,
				shoot_direction
			)

	is_shooting = false
	projectile_timer.start(projectile_cooldown)


func _calculate_new_jitter_movement():
	if is_dashing or is_dashing_imminent or is_shooting:
		jitter_move_direction = Vector2.ZERO
		return
		
	var player = get_tree().get_first_node_in_group("player")
	
	if is_instance_valid(player):
		var target_direction = (player.global_position - global_position).normalized()
		var target_angle = target_direction.angle()
		var max_angle_rad = deg_to_rad(jitter_max_angle)
		var random_offset = randf_range(-max_angle_rad, max_angle_rad)
		var new_angle = target_angle + random_offset
		jitter_move_direction = Vector2.RIGHT.rotated(new_angle).normalized()
	else:
		jitter_move_direction = Vector2.ZERO
		

# Dash-Mechanic

func _start_dash_anticipation():
	velocity = Vector2.ZERO
	is_dashing_imminent = true
	
	var player = get_tree().get_first_node_in_group("player")
	if is_instance_valid(player):
		dash_direction = (player.global_position - global_position).normalized()
	else:
		var random_angle = randf() * TAU
		dash_direction = Vector2(1, 0).rotated(random_angle).normalized()
		
	_draw_dash_indicator()
	
	dash_timer.start(dash_anticipation_time)

func _draw_dash_indicator():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + dash_direction * 10000)
	query.exclude = [get_rid()]
	var result = space_state.intersect_ray(query)

	var end_point: Vector2
	if result.is_empty():
		end_point = global_position + dash_direction * 10000
	else:
		end_point = result.position
		
	dash_indicator.clear_points()
	dash_indicator.add_point(Vector2.ZERO)
	dash_indicator.add_point(to_local(end_point))
	dash_indicator.visible = true

func _execute_dash():
	is_dashing_imminent = false
	is_dashing = true

	dash_indicator.visible = false

func _end_dash():
	is_dashing = false
	velocity = Vector2.ZERO
	
	movement_timer.start(dash_cooldown)
	
	_calculate_new_jitter_movement()
	movement_change_timer.start(jitter_change_time)

func _update_animation(current_velocity: Vector2, is_anticipating: bool = false):
	var new_animation: String = ""
	var is_moving = current_velocity.length_squared() > 0.01

	if is_moving or is_anticipating:
		current_look_direction = current_velocity if is_moving else dash_direction
	
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
	elif is_anticipating or is_shooting:
		new_animation = "idle_" + new_animation
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
		get_tree().change_scene_to_file("res://Scenes/Map/Gangster/gangster_secretroom.tscn")
