extends Node2D

# Exporteigenschaften für jede Waffe
@export var damage: int = 20
@export var skin: Texture2D # Ermöglicht die Auswahl der Grafik im Editor
@export var fire_rate: float = 0.5 # Zeit zwischen den Schüssen in Sekunden

const BULLET = preload("res://Scenes/Player/weapon/projectile/projectile.tscn")

@onready var muzzle: Marker2D = $Muzzle
@onready var sprite: Sprite2D = $Sprite2D
var can_shoot: bool = true

func _ready():
	# Weist dem Sprite die im Editor ausgewählte Grafik zu
	if skin:
		sprite.texture = skin

func attack():
	if can_shoot:
		can_shoot = false
		var bullet_instance = BULLET.instantiate()
		# Ruft die set_damage-Methode des Projektils auf, um den Schaden zu setzen
		bullet_instance.set_damage(damage)
		
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		
		# Warte auf die nächste Schussmöglichkeit
		var timer = get_tree().create_timer(fire_rate)
		timer.timeout.connect(reset_cooldown)

func reset_cooldown():
	can_shoot = true
