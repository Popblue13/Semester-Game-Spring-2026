extends CharacterBody2D


var player : CharacterBody2D
var SPEED : float = 400.0

func _physics_process(_delta: float) -> void:
	if player:
		var direction = position.direction_to(player.position)
		if position.distance_to(player.position) < 25:
			if not self.is_queued_for_deletion():
				player.queue_free()
			return
		var speed = SPEED * 100/position.distance_to(player.position)
		velocity = direction * speed
		move_and_slide()
		


func _on_range_body_entered(body: Node2D) -> void:
	if not body.get_collision_layer_value(4): # player not on interactable layer
		player = body


func _on_range_body_exited(_body: Node2D) -> void:
	player = null
