extends StaticBody2D

var player : Node2D
var enemy : CharacterBody2D
@onready var crane: StaticBody2D = $Crane


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		rotation = move_toward(rotation, get_angle_to(player.position), delta/2)
		crane.rotation =  move_toward(crane.rotation, get_angle_to(player.position), delta)
		clamp(rotation,-PI,PI)


func _on_range_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		return
	if not body.get_collision_layer_value(5): # if not on zombie layer
		if not body.get_collision_layer_value(2): # player isn't on zombie layer so safeguard
			return
	if not player:
		if body.get_collision_layer_value(2): # player layer
			if not body.get_collision_layer_value(4): # player not on interactable layer
				player = body
		elif body.get_collision_layer_value(3) and body != self: # enemy layer
			player = body
	elif not body.get_collision_layer_value(4): # player not on interactable layer
		enemy = body


func _on_range_body_exited(body: Node2D) -> void:
	if body == player:
		player = enemy
		enemy = null
	elif body == enemy:
		enemy = null


func _on_grabber_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.change_health(2)
