extends Node

static func damage_flash(owner_sprite: Sprite2D):
	if owner_sprite.material is ShaderMaterial:
		owner_sprite.material.set_shader_parameter("active", true)
		var timer = owner_sprite.get_tree().create_timer(0.1)
		timer.timeout.connect(func():
			owner_sprite.material.set_shader_parameter("active", false)
			)

static func update_animation(
	owner_sprite: Sprite2D, 
	owner_anim_player: AnimationPlayer, 
	current_velocity: Vector2, 
	is_anticipating: bool, 
	is_shooting: bool, 
	current_look_direction: Vector2
):
	var new_animation: String = ""
	var is_moving = current_velocity.length_squared() > 0.01

	var direction_to_check = current_velocity if is_moving else (current_look_direction if current_look_direction != Vector2.ZERO else Vector2.DOWN)
	
	var direction_x = direction_to_check.x
	var direction_y = direction_to_check.y
	
	if abs(direction_x) > abs(direction_y):
		new_animation = "side"
		owner_sprite.flip_h = direction_x < 0
	elif direction_y > 0:
		new_animation = "down"
		owner_sprite.flip_h = false
	else:
		new_animation = "up"
		owner_sprite.flip_h = false

	if is_moving:
		new_animation = "walk_" + new_animation
	elif is_anticipating or is_shooting:
		new_animation = "idle_" + new_animation
	else:
		new_animation = "idle_" + new_animation

	if owner_anim_player.current_animation != new_animation:
		owner_anim_player.play(new_animation)
