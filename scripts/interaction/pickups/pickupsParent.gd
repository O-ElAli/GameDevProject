extends InteractionArea
class_name Pickup

@export var item_name := "Item"
@export var icon : Texture2D
@export var vanishes:= true
var items_held : Array = []



func _ready():
	print("Item ready triggered")
	super._ready()
	if icon:
		$Sprite2D.texture = icon

func interact() -> void:
	if item_name not in items_held:
		items_held.append(item_name)
		print(items_held)
		if vanishes:
				queue_free()
	# 1. Pick up the item -> remove item (hide)
	# 2. Add item to list of items (inventory)
	
