extends InteractionArea
class_name Pickup

@export var item_name := "Item"
@export var icon : Texture2D
@export var vanishes:= true
@export var reveals_and_stays_vanished := true
@export var reveal_target: NodePath
@export var teleport_marker: NodePath 

signal interaction_finished(item_name)
var items_held : Array = []



func _ready():
	print("Item ready triggered")
	super._ready()
	if icon:
		$Sprite2D.texture = icon
	if item_name in SceneManager.items_held and reveals_and_stays_vanished: 
		queue_free() 

func interact() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if teleport_marker != NodePath(""):
		var target_node = get_node(teleport_marker)
		if target_node:
			player.global_position = target_node.global_position
			print("Player teleported to marker")
	
	if item_name not in SceneManager.items_held: 
		SceneManager.items_held.append(item_name) 
		print(SceneManager.items_held)
		if vanishes:
			queue_free()
	
	if reveal_target != NodePath(""):
		var target = get_node(reveal_target)
		if target:
			target.show()
	emit_signal("interaction_finished", item_name)
