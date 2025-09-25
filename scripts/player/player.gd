extends CharacterBody2D

@export var movement_speed: float = 300.0

var character_direction: Vector2

var allow_movement:= true



func _ready() -> void:
	add_to_group("player")
	change_weapon(PISTOL_SCENE)

@onready var weapon_hand = $Hand

var current_weapon = null

const PISTOL_SCENE = preload("res://Scenes/Player/weapon/Pistol.tscn")
const RIFLE_SCENE = preload("res://Scenes/Player/weapon/Rifle.tscn")
const SHOTGUN_SCENE = preload("res://Scenes/Player/weapon/Shotgun.tscn")

func _physics_process(_delta: float) -> void:
	
	if not allow_movement:
		velocity = Vector2.ZERO
		if $sprite.animation != "Idle":
			$sprite.animation = "Idle"
		move_and_slide()
		return
	
	character_direction = Vector2(0,0)
	
	if Input.is_action_pressed("move_down"):
		character_direction.y = 1
	elif Input.is_action_pressed("move_up"):
		character_direction.y = -1
	elif Input.is_action_pressed("move_right"):
		character_direction.x = 1
	elif Input.is_action_pressed("move_left"):
		character_direction.x = -1
	
	#Animation	
	if character_direction.x > 0: $sprite.animation = "Right"
	elif character_direction.x < 0: $sprite.animation = "Left"
	elif character_direction.y > 0: $sprite.animation = "Down"
	elif character_direction.y < 0: $sprite.animation = "Up"
	
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if $sprite.animation != "Idle": $sprite.animation = "Idle"
	
	
	velocity = character_direction * movement_speed
	move_and_slide()

func set_movement_allowed(allowed:bool) -> void:
	allow_movement = allowed
	if not allowed:
		velocity = Vector2.ZERO
	
func _process(delta: float):
	if current_weapon:
		current_weapon.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		if current_weapon:
			current_weapon.attack()
	if Input.is_action_just_pressed("weapon_2"):
		change_weapon(RIFLE_SCENE)
	if Input.is_action_just_pressed("weapon_1"):
		change_weapon(PISTOL_SCENE)


func change_weapon(new_weapon_scene):
	if current_weapon:
		current_weapon.queue_free()
		
	var new_weapon_instance = new_weapon_scene.instantiate()
	weapon_hand.add_child(new_weapon_instance)
	current_weapon = new_weapon_instance
