extends Node2D

@export var radius: float = 40.0
@export var visible_debug: bool = true
@export var col_shape: CollisionShape2D 


func _process(_delta: float):
	if visible_debug:
		queue_redraw()


func _draw() -> void:
	if visible_debug:
		draw_circle(Vector2.ZERO, radius, Color(1, 0, 0, 0.3))
