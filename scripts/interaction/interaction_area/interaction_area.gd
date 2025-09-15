extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

func interact():
	pass

func _ready() -> void:
	print("Interaction area ready!")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("player"):
		print("entered body")
		InteractionManager.register_area(self)
	else:
		print("Body not in player")

func _on_body_exited(_body: CharacterBody2D) -> void:
	InteractionManager.unregister_area(self)
	print("Body exited")
