extends CharacterBody2D


const SPEED = 100.0
var target : CharacterBody2D

func _physics_process(delta: float) -> void:
	if target:
		rotation = move_toward(rotation,global_position.direction_to(
								target.global_position).angle()-PI, delta*3)
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * SPEED
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		var collision = get_last_slide_collision().get_collider_shape()
		if collision is CollisionShape2D and collision.get_parent().get_collision_layer_value(2):
			collision.get_parent().queue_free()
