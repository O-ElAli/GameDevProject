extends CharacterBody2D
@export var health: int = 100
@onready var sprite = $Sprite2D
@onready var healthbar: ProgressBar = $Healthbar
@onready var damage_number_point: Node2D = $"../DamageNumberPoint"

func _ready():
	healthbar.value = health
	if sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("active", false)
		
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
