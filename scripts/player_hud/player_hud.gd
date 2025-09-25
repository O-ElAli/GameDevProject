class_name playerHUD extends Control


@export var font_file: FontFile
@export var font_size: int = 20
@export var font_color: Color = Color(1, 1, 1)

@export var inventory: Node

@onready var mission: Label = $TabContainer/Mission/mission_log
@onready var items_container: VBoxContainer = $TabContainer/Inventory/MarginContainer/items


func _ready():
	#if inventory:
		#inventory.inventory_changed.connect(_refresh_inventory)
	#_refresh_inventory()
	pass

#func _refresh_inventory() -> void:
	## Alte Einträge löschen
	#for child in items_container.get_children():
		#child.queue_free()
	#if not inventory:
		#return
#
	## Neue Items einfügen
	#for id in inventory.items.keys():
		#var count: int = inventory.items[id]
		#var item_data = _get_item_data_by_id(id)
		#if not item_data:
			#continue
		#var hbox = HBoxContainer.new()
#
		## Icon
		#var icon_rect = TextureRect.new()
		#icon_rect.texture = item_data.icon
		#icon_rect.custom_minimum_size = Vector2(32, 32)
		#hbox.add_child(icon_rect)
#
		## Label mit Font und Farbe
		#var lbl = Label.new()
		#lbl.text = "%dx %s" % [count, item_data.display_name]
		#lbl.label_settings = _make_label_settings()
		#hbox.add_child(lbl)
		#items_container.add_child(hbox)

func _on_exit_pressed() -> void:
	hide()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Start_Screen/start_screen.tscn")


func _on_save_pressed() -> void:
	pass # Replace with function body.

func update_mission(text: String) -> void:
	mission.text = text

func _make_label_settings() -> LabelSettings:
	var settings = LabelSettings.new()
	if font_file:
		settings.font = font_file
	settings.font_size = font_size
	settings.font_color = font_color
	return settings

func _get_item_data_by_id(id: String) -> Resource:
	var path = "res://items/%s.tres" % id
	if ResourceLoader.exists(path):
		return ResourceLoader.load(path)
	push_warning("ItemData not found for id: %s" % id)
	return null
