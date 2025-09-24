extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Sprite


func _ready():
	#print("Key ready:", self.name, "area: ", interaction_area)
	#interaction_area.interact = Callable(self, "_on_interact")
	pass

func _on_interact():
	print("Key picked up!")
