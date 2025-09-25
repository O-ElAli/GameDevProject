extends CanvasLayer
class_name DialogueSystemNode

var is_active: bool = false
var current_npc = null
var line_index: int = 0

@onready var dialogue_ui: Control = $UI
@onready var text_label: RichTextLabel = $UI/PanelContainer/RichTextLabel
@onready var name_label: Label = $UI/Name

func _ready() -> void:
	hide_dialogue()

func start_dialogue(npc) -> void:
	current_npc = npc
	is_active = true
	dialogue_ui.visible = true
	name_label.text = npc.npc_name
	line_index = 0
	_show_next_line()

func _show_next_line() -> void:
	if current_npc == null:
		return
	if line_index < current_npc.dialogue_lines.size():
		text_label.bbcode_text = current_npc.dialogue_lines[line_index]
		await display_text_animated(current_npc.dialogue_lines[line_index])
		line_index += 1
	else:
		hide_dialogue()

func display_text_animated(text: String) -> void:
	text_label.text = ""
	for i in range(text.length()):
		text_label.text += text[i]
		await get_tree().create_timer(0.05).timeout

func hide_dialogue() -> void:
	is_active = false
	current_npc = null
	dialogue_ui.visible = false
	line_index = 0
