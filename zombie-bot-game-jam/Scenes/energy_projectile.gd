extends CharacterBody2D



func _physics_process(_delta: float) -> void:
	var collider = move_and_collide(velocity/100)
	if collider:
		queue_free()
