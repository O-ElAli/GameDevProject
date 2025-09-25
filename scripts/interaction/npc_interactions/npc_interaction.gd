extends InteractionArea
class_name npc_interaction

@export var npc_name: String
@export var dialogue_system_path: NodePath

@onready var dialogue_system = get_node(dialogue_system_path)


var dialogue_lines: Array = []

var lines_dict = {
	"Igor": [
		'Hello, I\'m Igor!',
		'Nice to meet you!'
	]
}

func _ready():
	super._ready()
	print("=== NPC Debug Info ===")
	print("NPC Name: ", npc_name)
	print("Dialogue System Path: ", dialogue_system_path)
	print("Dialogue System Node: ", dialogue_system)
	print("Dialogue Lines: ", dialogue_lines)
	print("======================")
	if lines_dict.has(npc_name):
		print("if")
		dialogue_lines = lines_dict[npc_name]
	else:
		print("else")
		dialogue_lines = ["Hello!"]

func interact():
	print("=== INTERACT CALLED ===")
	print("NPC: ", npc_name)
	if lines_dict.has(npc_name):
		dialogue_lines = lines_dict[npc_name]
	else:
		dialogue_lines = ["Hello!"]
	
		# THIS IS THE CRITICAL PART YOU'RE MISSING:
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
