extends CharacterBody2D


const SPEED = 1000.0
var target : CharacterBody2D

func _physics_process(delta: float) -> void:
	if target:
		if target.is_queued_for_deletion():
			target = null
			return
		var direction : Vector2 = global_position.direction_to(target.global_position)
		velocity = direction * SPEED

	move_and_slide()
