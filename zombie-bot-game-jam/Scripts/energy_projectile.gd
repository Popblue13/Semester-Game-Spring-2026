extends CharacterBody2D



func _physics_process(_delta: float) -> void:
	var collider = move_and_collide(velocity/100)
	if collider:
		if collider.get_collider_shape_index() == 0:
			collider.get_collider_shape().get_parent().queue_free()
		queue_free()
		
