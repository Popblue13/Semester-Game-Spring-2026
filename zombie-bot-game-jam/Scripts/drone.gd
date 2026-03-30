extends CharacterBody2D


var player : CharacterBody2D # aka, first priority target
var enemy : CharacterBody2D # aka, second priority target
var SPEED : float = 400.0
const energy_projectile : PackedScene = preload("res://Scenes/Dungeon Objects/energy_projectile.tscn")
var charge : float = 0.0

func _physics_process(delta: float) -> void:
	if player:
		var direction : Vector2 = position.direction_to(player.position)
		var speed : float
		
		
		#make projectile
		if charge_gun(delta):
			var instance = energy_projectile.instantiate()
			get_parent().add_child(instance)
			instance.position = position
			instance.set_collision_mask_value(2, true) #set to hit the player
			instance.set_collision_mask_value(5, true) #set to hit zombies only
			instance.velocity = direction * 2 * SPEED
			instance.rotation = instance.velocity.angle()
		
		if position.distance_to(player.position) == 0: 
			return #prevents dividing by zero
		if position.distance_to(player.position) < 100:
			speed = SPEED * 100/position.distance_to(player.position)
			velocity = -direction * speed
		elif position.distance_to(player.position) > 200:
			speed = SPEED * 100/position.distance_to(player.position)
			velocity = direction * speed
		else:
			velocity = velocity.move_toward(Vector2(0,0), delta*SPEED)
		move_and_slide()
	else:
		charge_gun(delta)

func charge_gun(delta: float) -> bool:
	charge += delta
	if charge > 2: # ~4 seconds to charge
		charge = 0
		return true # is charged
	else:
		return false


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
