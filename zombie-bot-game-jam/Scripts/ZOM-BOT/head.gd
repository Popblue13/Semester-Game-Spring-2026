extends CharacterBody2D

const energy_projectile = preload("res://Scenes/Dungeon Objects/energy_projectile.tscn")
const SPEED = 300.0
var charge : float = 0
var target : CharacterBody2D
var boss_health : int = 15
@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	if boss_health <= 0:
		get_parent().queue_free()
		return
	elif boss_health == 10 and timer.is_stopped():
		timer.start()
	
	if target:
		var direction : Vector2 = global_position.direction_to(target.global_position)
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
		
		if global_position.distance_to(target.global_position) == 0: 
			return #prevents dividing by zero
		if global_position.distance_to(target.global_position) < 300:
			speed = SPEED * 100/global_position.distance_to(target.global_position)
			velocity = -direction * speed
		elif global_position.distance_to(target.global_position) > 500:
			speed = SPEED * 100/global_position.distance_to(target.global_position)
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
	if body.get_collision_mask_value(1) and body.get_collision_mask_value(3):
		body.queue_free()
		boss_health -= 1
		print("owie, I hurted:", boss_health)
