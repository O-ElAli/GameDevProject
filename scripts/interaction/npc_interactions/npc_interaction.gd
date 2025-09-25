extends InteractionArea
class_name npc_interaction

@export var npc_name: String
@export var dialogue_system_path: NodePath

@onready var dialogue_system = get_node(dialogue_system_path)


func _ready():
	super._ready()
	pass

func _interact(name):
	if dialogue_system:
		dialogue_system.start_dialogue(self)
	else:
		print("Dialogue system not found for NPC: " + npc_name)

"""
what does the npc interaction class need?
npc name
dialogue_system path

on interact:
	send trigger interaction with npc name
"""
