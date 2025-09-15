extends CanvasLayer
class_name DialogSystemNode

var is_active: bool = false
var current_npc = null
var line_index: int = 0

@onready var dialog_ui: Control = $UI
@onready var text_label: RichTextLabel = $UI/PanelContainer/RichTextLabel
@onready var name_label: Label = $UI/Name

func _ready() -> void:
	hide_dialog()

func start_dialog(npc) -> void:
	current_npc = npc
	is_active = true
	dialog_ui.visible = true
	name_label.text = npc.npc_name
	line_index = 0
	_show_next_line()

func _show_next_line() -> void:
	if current_npc == null:
		return
	if line_index < current_npc.dialogue_lines.size():
		text_label.bbcode_text = current_npc.dialogue_lines[line_index]
		line_index += 1
	else:
		hide_dialog()

func hide_dialog() -> void:
	is_active = false
	current_npc = null
	dialog_ui.visible = false
	line_index = 0
