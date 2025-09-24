extends CharacterBody2D

@export var movement_speed: float = 300.0

var character_direction: Vector2

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	
	character_direction = Vector2(0,0)
	
	if Input.is_action_pressed("move_down"):
		character_direction.y = 1
	elif Input.is_action_pressed("move_up"):
		character_direction.y = -1
	elif Input.is_action_pressed("move_right"):
		character_direction.x = 1
	elif Input.is_action_pressed("move_left"):
		character_direction.x = -1
	
	#Animation	
	if character_direction.x > 0: $sprite.animation = "Right"
	elif character_direction.x < 0: $sprite.animation = "Left"
	elif character_direction.y > 0: $sprite.animation = "Down"
	elif character_direction.y < 0: $sprite.animation = "Up"
	
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if $sprite.animation != "Idle": $sprite.animation = "Idle"
	
	
	velocity = character_direction * movement_speed
	move_and_slide()
