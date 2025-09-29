extends Control
@export var display_text: String = ""  


func _ready() -> void:
	var label = $Label
	if label and display_text != "":
		label.text = display_text 

func _on_exit_pressed() -> void:
	hide()
