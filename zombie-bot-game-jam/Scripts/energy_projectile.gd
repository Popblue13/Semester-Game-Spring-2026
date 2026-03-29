extends CharacterBody2D



func _physics_process(_delta: float) -> void:
	var collider = move_and_collide(velocity/100)
	if collider:
		if collider.get_collider_shape():
			if collider.get_collider_shape().get_parent() is StaticBody2D:
				pass
			elif collider.get_collider_shape().get_parent() is CharacterBody2D:
				if collider.get_collider_shape().get_parent().get_collision_layer_value(4):
					return
				else:
					if collider.get_collider_shape_index() == 0:
						if not collider.get_collider_shape().get_parent().get_collision_layer_value(1):
							collider.get_collider_shape().get_parent().queue_free()
			elif collider.get_collider_shape_index() == 0:
				if not collider.get_collider_shape().get_parent().get_collision_layer_value(1):
					collider.get_collider_shape().get_parent().queue_free()
		queue_free()
		
