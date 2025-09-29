extends CharacterBody2D

@export var player_health: int = 100

@export var movement_speed: float = 300.0

var character_direction: Vector2

var allow_movement:= true
var last_direction := "Down"
var idle_timer := 0.0

@onready var sprite: AnimatedSprite2D = $sprite
@onready var weapon_hand = $Hand
@onready var hud = $CanvasLayer/PlayerHud

var current_weapon = null

const PISTOL_SCENE = preload("res://Scenes/Player/weapon/Pistol.tscn")
const RIFLE_SCENE = preload("res://Scenes/Player/weapon/Rifle.tscn")
const SHOTGUN_SCENE = preload("res://Scenes/Player/weapon/Shotgun.tscn")

func _ready() -> void:
	add_to_group("player")
	change_weapon(PISTOL_SCENE)
	
	SceneManager.restore_player_position(self, get_tree().current_scene.scene_file_path)


func _physics_process(_delta: float) -> void:
	
	if not allow_movement:
		velocity = Vector2.ZERO
		_show_idle()
		move_and_slide()
		return
	
	character_direction = Vector2(0,0)
	
	if Input.is_action_pressed("move_down"):
		character_direction.y = 1
		last_direction = "Down"
	elif Input.is_action_pressed("move_up"):
		character_direction.y = -1
		last_direction = "Up"
	elif Input.is_action_pressed("move_right"):
		character_direction.x = 1
		last_direction = "Right"
	elif Input.is_action_pressed("move_left"):
		character_direction.x = -1
		last_direction = "Left"
	
	if character_direction != Vector2.ZERO:
		velocity = character_direction.normalized() * movement_speed
		sprite.play(last_direction)
		idle_timer = 0.0  
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		idle_timer += _delta
		if idle_timer > 0.2:  
			_show_idle()
	
	move_and_slide()

func _show_idle() -> void:
	sprite.animation = last_direction
	sprite.frame = 0
	sprite.stop()

func set_movement_allowed(allowed:bool) -> void:
	allow_movement = allowed
	if not allowed:
		velocity = Vector2.ZERO
		_show_idle()
	
func _process(delta: float):
	# checken ob Maus link vom Spieler ist, für Waffenflip
	var mouse_left_of_player: bool = get_global_mouse_position().x < global_position.x
	if current_weapon:
		current_weapon.look_at(get_global_mouse_position())
		if current_weapon.has_method("flip_weapon"):
			current_weapon.flip_weapon(mouse_left_of_player)
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


func _on_button_pressed() -> void:
	$CanvasLayer/Button.hide()
	set_movement_allowed(false) 
	hud.visible = true
	#if hud:
		#hud.visible = true
func take_damage(amount: int):
	if player_health <= 0:
		return
		
	player_health -= amount
	print("Spieler hat ", player_health, " Lebenspunkte übrig.")
	# damage_flash() 
	if player_health <= 0:
		_die()
		
func _die():
	print("Game Over!")
