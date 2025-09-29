extends CanvasLayer
class_name DialogueSystemNode

var is_active: bool = false
var current_npc = null
var line_index: int = 0
signal dialogue_finished

@onready var dialogue_ui: Control = $UI
@onready var text_label: RichTextLabel = $UI/PanelContainer/RichTextLabel
@onready var name_label: Label = $UI/Name

func _ready() -> void:
	hide_dialogue()
	add_to_group("dialogue_system")
	connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))

func start_dialogue(npc) -> void:
	print("=== DIALOGUE START ===")
	print("NPC: ", npc.npc_name)
	print("Dialogue Lines: ", npc.dialogue_lines)
	current_npc = npc
	is_active = true
	dialogue_ui.visible = true
	name_label.text = npc.npc_name
	line_index = 0
	
	
	_freeze_movements(true)
	
	
	_show_next_line()

func _show_next_line() -> void:
	if current_npc == null:
		return
		
	print("Showing line ", line_index, " of ", current_npc.dialogue_lines.size())
	
	if line_index < current_npc.dialogue_lines.size():
		var line = current_npc.dialogue_lines[line_index]
		
		if typeof(line) == TYPE_DICTIONARY:
			if line.has("name"):
				name_label.text = line["name"]
			if line.has("text"):
				text_label.bbcode_text = line["text"]
		
		elif typeof(line) == TYPE_STRING:
			text_label.bbcode_text = line
		
		else:
			text_label.bbcode_text = str(line)
		
		line_index += 1
	else:
		hide_dialogue()
		emit_signal("dialogue_finished")


func display_text_animated(text: String) -> void:
	text_label.text = ""
	for i in range(text.length()):
		text_label.text += text[i]
		await get_tree().create_timer(0.05).timeout

func hide_dialogue() -> void:
	print("=== Dialogue end ===")
	is_active = false
	current_npc = null
	dialogue_ui.visible = false
	line_index = 0
	
	_freeze_movements(false)

func _input(event: InputEvent) -> void:
	if is_active and event.is_action_pressed("interact"):
		print("Dialuge system handling interact input")
		_show_next_line()
		get_tree().get_root().set_input_as_handled()

func _freeze_movements(freeze: bool) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("set_movement_allowed"):
		player.set_movement_allowed(not freeze)
	var npcs = get_tree().get_nodes_in_group("npc")
	for npc in npcs:
		if npc.has_method("set_behavior_allowed"):
			npc.set_behavior_allowed(not freeze)
