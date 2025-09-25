extends Area2D

const SPEED: int = 300
var damage: int # Wir verwenden "var" anstelle von "@export var", da der Wert von der Waffe gesetzt wird

func _ready():
	# Optional: Debug-Ausgabe des Schadens
	print("Projektil instanziiert mit ", damage, " Schaden.")

# Eine neue Methode, um den Schadenswert von der Waffe zu setzen
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
