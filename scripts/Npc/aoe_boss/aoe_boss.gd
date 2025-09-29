extends Node2D

@export var explosion_damage: int = 30
@export var explosion_radius: float = 50.0

@onready var aoe_timer: Timer = $Timer
@onready var aoe_area: Area2D = $Area2D
@onready var aoe_collision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var explosion_animation: AnimatedSprite2D = $AnimatedExplosion

var has_exploded_damage: bool = false
var anticipation_time: float

var damaged_bodies: Array[Object] = []

func _ready():
	# Reichweite der Explosion in RD (mit Ruler Collisionshape gemessen)
	if aoe_collision.shape is CircleShape2D:
		(aoe_collision.shape as CircleShape2D).radius = explosion_radius
	
	# Collision ist per Default in AoeVoid-Szene auf aus, wird aktiviert in _execute_explosion
	aoe_collision.set_deferred("disabled", true)
	
	# Explosionszeit in der der Spieler die Explosion wahrnehmen kann
	anticipation_time = 3.0 
	
	aoe_timer.one_shot = true
	aoe_timer.timeout.connect(_execute_explosion)
	aoe_timer.start(anticipation_time)
	
	explosion_animation.play("schockwave")
	
	aoe_area.body_entered.connect(_on_body_entered_during_explosion)


func _execute_explosion():
	if has_exploded_damage: return
	has_exploded_damage = true
	
	# Kollision aktivieren
	aoe_collision.set_deferred("disabled", false)
	
	await get_tree().process_frame
	
	# Schaden draufrechnen
	_apply_damage_to_overlapping_bodies()
	
	await get_tree().create_timer(0.1).timeout
	
	queue_free()


func _on_body_entered_during_explosion(body):
	if has_exploded_damage and body.is_in_group("player") and body not in damaged_bodies:
		if body.has_method("take_damage"):
			body.take_damage(explosion_damage)
			damaged_bodies.append(body)

func _apply_damage_to_overlapping_bodies():
	var bodies = aoe_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player") and body.has_method("take_damage") and body not in damaged_bodies:
			body.take_damage(explosion_damage)
			damaged_bodies.append(body)

func _on_timer_timeout() -> void:
	pass
