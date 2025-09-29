extends CanvasLayer

func _ready():
	var bus := AudioServer.get_bus_index("Master")
	var db = AudioServer.get_bus_volume_db(bus)
	$MarginContainer/VBoxContainer/Volume.value = db_to_linear(db) * 100
	
	$MarginContainer/VBoxContainer/Mute.button_pressed = AudioServer.is_bus_mute(bus)
	
	$MarginContainer/VBoxContainer/Fullscreen.button_pressed = (
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	)

func _on_volume_value_changed(value: float) -> void:
	var bus := AudioServer.get_bus_index("Master")
	var linear = value / 100.0
	AudioServer.set_bus_volume_db(bus, linear_to_db(linear))

func _on_mute_toggled(toggled_on: bool) -> void:
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus, toggled_on)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_back_pressed() -> void:
	queue_free() 
