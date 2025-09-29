extends Node2D

@export var damage: int = 15
@export var skin: Texture2D
@export var fire_rate: float = 0.15

const BULLET = preload("res://Scenes/Player/weapon/projectile/projectile.tscn")

@onready var muzzle: Marker2D = $Muzzle
@onready var sprite: Sprite2D = $Sprite2D
var can_shoot: bool = true
var is_flipped: bool = false

func _ready():
	if skin:
		sprite.texture = skin

func attack():
	if can_shoot:
		can_shoot = false
		var bullet_instance = BULLET.instantiate()
		bullet_instance.set_damage(damage)
		
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		
		var timer = get_tree().create_timer(fire_rate)
		timer.timeout.connect(reset_cooldown)

func reset_cooldown():
	can_shoot = true
