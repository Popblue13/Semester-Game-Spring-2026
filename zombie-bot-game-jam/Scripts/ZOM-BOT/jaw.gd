extends CharacterBody2D


const SPEED = 300.0
@onready var head : CharacterBody2D = get_parent()

func _physics_process(delta: float) -> void:
	if get_parent().target:
		if get_parent().target.global_position.distance_to(head.global_position) > 100:
			if global_position.distance_to(get_parent().target.global_position) < 275:
				targeting_system(head, delta)
			elif global_position.distance_to(get_parent().target.global_position) > 300:
				targeting_system(get_parent().target, delta)
			else:
				velocity = velocity.move_toward(Vector2(0,0), delta)
		elif global_position.distance_to(head.global_position) < 50:
			velocity = Vector2(0,0)
		else:
			targeting_system(head, delta/4)
		
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		var collision = get_last_slide_collision().get_collider_shape()
		if collision is CollisionShape2D and collision.get_parent().get_collision_layer_value(2):
			collision.get_parent().change_health(3*delta)

func targeting_system(target : CharacterBody2D, delta : float):
	rotation = move_toward(rotation,global_position.direction_to(
									target.global_position).angle(), delta)
	var direction = global_position.direction_to(target.global_position)
	velocity = direction * SPEED


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not CharacterBody2D:
		return
	if body.get_collision_mask_value(1) and body.get_collision_mask_value(3):
		body.queue_free()
