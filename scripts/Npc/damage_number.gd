extends Node

func display_damage(value: int, position: Vector2):
	
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	
	var settings = LabelSettings.new()

	settings.font_color = Color("#FFF")
	if value == 0:
		settings.font_color = Color("#FFF8")
		
	settings.font_size = 18
	settings.outline_color = Color("#000")
	settings.outline_size = 1
	
	number.label_settings = settings
	
	call_deferred("add_child", number)
	
	await number.resized
	#Zentrieren
	number.pivot_offset = number.size / 2
	
	var tween = create_tween()
	
	# Damagevisual hoch bewegen
	tween.tween_property(
		number, "global_position:y", number.global_position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	
	# In der Luft halten
	tween.tween_interval(0.5) 
	
	# verkleinern und objekt free
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN)
		
	await tween.finished
	number.queue_free()
