extends InteractionArea
class_name NPCInteraction

@export var npc_name: String
@export var dialogue_system_path: NodePath

@onready var dialogue_system = get_node(dialogue_system_path)

var dialogue_lines: Array = []

func _ready():
	super._ready()
	refresh_dialogue()
	
func refresh_dialogue():
	# Get current NPC state and update dialogue
	var current_state = GameState.get_npc_state(npc_name)
	dialogue_lines = DialogueDatabase.get_dialogue(npc_name, current_state)
	print("NPC: ", npc_name, " | State: ", current_state, " | Dialogue: ", dialogue_lines)

func interact():
	print("=== INTERACT WITH ", npc_name, " ===")
	
	# First, try to complete any quest for this NPC
	if QuestDatabase.try_complete_quest(npc_name):
		# Quest was completed, refresh dialogue to show completion lines
		refresh_dialogue()
	
	# Then start dialogue with updated lines
	if dialogue_system:
		dialogue_system.start_dialogue(self)
	else:
		print("Dialogue system not found for NPC: " + npc_name)
