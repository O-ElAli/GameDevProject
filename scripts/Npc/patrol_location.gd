@tool
class_name PatrolLocation
extends Node2D

signal tranform_changed

@export var wait_time: float = 0.0:
	set(value):
		wait_time = value
		_update_wait_label()

var target_position: Vector2

func _enter_tree() -> void:
	set_notify_transform(true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		tranform_changed.emit()

func _ready() -> void:
	target_position = global_position
	_update_wait_label()
	if not Engine.is_editor_hint():
		if has_node("Way"):
			$Way.queue_free()

func update_label(text: String) -> void:
	if has_node("Way/Label"):
		$Way/Label.text = text

func update_line(next_pos: Vector2) -> void:
	if has_node("Way/Line2D"):
		var line := $Way/Line2D
		line.points[1] = next_pos - position

func _update_wait_label() -> void:
	if Engine.is_editor_hint() and has_node("Way/Label2"):
		$Way/Label2.text = "wait: " + str(snappedf(wait_time, 0.1)) + "s"
