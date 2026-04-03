extends CharacterBody2D

const energy_projectile = preload("res://Scenes/Dungeon Objects/energy_projectile.tscn")
const SPEED = 350.0
var charge : float = 0
@onready var timer: Timer = $Timer
@onready var player : CharacterBody2D = $"../../player"
@onready var energy_boxes: Node2D = $"../EnergyBoxes"
var boss_health = 3
var chasing : bool = false
@onready var return_spot: Node2D = $".."
var go_back : bool = false

func _physics_process(delta: float) -> void:
	if energy_boxes.get_child_count() == 2 and boss_health == 3:
		boss_health = 2
		timer.start(7)
		chasing = true
	elif energy_boxes.get_child_count() == 1 and boss_health == 2:
		boss_health = 1
		timer.start(14)
		chasing = true
	elif energy_boxes.get_child_count() == 0 and boss_health == 1:
		queue_free()
		
	if is_queued_for_deletion():
		return
		
	
	if player:
		var direction : Vector2 = global_position.direction_to(player.global_position)
		var speed : float
		
		#make projectile
		if charge_gun(delta):
			var instance = energy_projectile.instantiate()
			get_parent().add_child(instance)
			instance.scale *= 5
			instance.position = position
			instance.set_collision_mask_value(2, true) #set to hit the player
			instance.velocity = direction * SPEED
			instance.rotation = instance.velocity.angle()
		
		if chasing:
			direction = global_position.direction_to(player.global_position)
			speed = SPEED
			if global_position.distance_to(player.global_position) < 100:
				speed += SPEED
			velocity = direction * speed
		elif global_position.distance_to(return_spot.global_position) > 100 and go_back:
			direction = global_position.direction_to(return_spot.global_position)
			speed = global_position.distance_to(return_spot.global_position)
			velocity = direction * speed
		else:
			go_back = false
			if global_position.distance_to(player.global_position) == 0: 
				return #prevents dividing by zero
			if global_position.distance_to(player.global_position) < 300:
				speed = SPEED * 100/global_position.distance_to(player.global_position)
				velocity = -direction * speed
			elif global_position.distance_to(player.global_position) > 500:
				speed = SPEED * 100/global_position.distance_to(player.global_position)
				velocity = direction * speed
			else:
				velocity = velocity.move_toward(Vector2(0,0), delta*SPEED)
		move_and_slide()
	else:
		charge_gun(delta)
	

func charge_gun(delta: float) -> bool:
	charge += delta
	if charge > 1.3: # 2.6 seconds
		if charge > 2: # shoot for 1.4 seconds
			charge = 0
		return true # is charged
	else:
		return false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not CharacterBody2D:
		return
	body.change_health(2)


func _on_timer_timeout() -> void:
	chasing = false #head back
	go_back = true
	pass # Replace with function body.
