class_name NPCBehavior
extends Node2D

var npc: NPC

func _ready() -> void:
	var parent = get_parent()
	if parent is NPC:
		npc = parent
		npc.behavior_ready.connect(_on_behavior_ready)

func _on_behavior_ready() -> void:
	pass
