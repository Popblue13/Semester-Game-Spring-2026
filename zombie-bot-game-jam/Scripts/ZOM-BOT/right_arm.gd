extends CharacterBody2D


const SPEED = 300.0
var target : CharacterBody2D

func _physics_process(delta: float) -> void:
	if target:
		var mod : float = 2.5
		var diff = rotation - global_position.direction_to(target.global_position).angle()
		if abs(diff) > PI:
			mod += abs(diff) * 3
			mod *= diff/abs(diff)
		rotation = move_toward(rotation,global_position.direction_to(
								target.global_position).angle(), delta/2 * mod)
		if rotation == global_position.direction_to(target.global_position).angle():
			var direction = global_position.direction_to(target.global_position)
			velocity = direction * SPEED
	move_and_slide()
	if get_slide_collision_count() > 0:
		var collision = get_last_slide_collision().get_collider_shape()
		if collision is CollisionShape2D and collision.get_parent().get_collision_layer_value(2):
			collision.get_parent().queue_free()

func _on_left_area_body_entered(body: Node2D) -> void:
	if body is not CharacterBody2D:
		return
	if body.get_collision_mask_value(1) and body.get_collision_mask_value(3):
		body.queue_free()


func _on_right_area_body_entered(body: Node2D) -> void:
	if body is not CharacterBody2D:
		return
	if body.get_collision_mask_value(1) and body.get_collision_mask_value(3):
		body.queue_free()
