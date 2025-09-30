extends Node2D

@onready var player = $Player
@onready var spawn_marker = $start

func _ready() -> void:
	if player and spawn_marker:
		player.global_position = spawn_marker.global_position
