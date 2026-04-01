extends CharacterBody2D

var health : float = 1
var player : CharacterBody2D # aka, first priority target
var enemy : CharacterBody2D # aka, second priority target
var SPEED : float = 400.0

func _physics_process(delta: float) -> void:
	if health <= 0:
		queue_free()
		return
	
	if player:
		var direction = position.direction_to(player.position)
		if position.distance_to(player.position) < 25:
			if not self.is_queued_for_deletion():
				player.change_health(2.5*delta)
			return
		var speed = SPEED * 100/position.distance_to(player.position)
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = clamp(velocity.move_toward(Vector2(0,0),delta*10),
							Vector2(-SPEED,-SPEED), Vector2(SPEED,SPEED))
		move_and_slide()


func _on_range_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		return
	if body.get_collision_layer_value(5): # if on zombie layer
		return
	if not player:
		if body.get_collision_layer_value(2): # player layer
			if not body.get_collision_layer_value(4): # player not on interactable layer
				player = body
		elif body.get_collision_layer_value(3) and body != self: # enemy layer
			player = body
	elif not body.get_collision_layer_value(4):
		enemy = body


func _on_range_body_exited(body: Node2D) -> void:
	if body == player:
		player = enemy
		enemy = null

func change_health(health_taken:float) -> void:
	health -= health_taken
