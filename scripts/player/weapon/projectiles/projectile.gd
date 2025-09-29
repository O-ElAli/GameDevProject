extends Area2D

const SPEED: int = 600
var damage: int

func _ready():
	print("Projektil instanziiert mit ", damage, " Schaden.")

func set_damage(amount: int):
	damage = amount

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
 
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
	
	queue_free()
 
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
