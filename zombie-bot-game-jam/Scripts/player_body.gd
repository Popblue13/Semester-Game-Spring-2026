extends CharacterBody2D


const SPEED = 300.0
var x_direction_input : String = ""
var y_direction_input : String = ""
var override_direction_input : String = ""
@onready var claws_hitbox: CollisionShape2D = $Claws/ClawsHitbox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_hurtbox: CollisionShape2D = $PlayerHurtbox
@onready var sprite_position : Vector2 = Vector2(0,0)
const energy_projectile : PackedScene = preload("res://Scenes/energy_projectile.tscn")
var last_direction : String = "right"

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		x_direction_input = "right"
		if not y_direction_input:
			override_direction_input = "right"
		last_direction = "right"
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		x_direction_input = "left"
		if not y_direction_input:
			override_direction_input = "left"
		last_direction = "left"
	else: # make go straight to zero if we want it to not slide afterwards
		if x_direction_input == override_direction_input:
			x_direction_input = ""
			override_direction_input = y_direction_input
		velocity.x = move_toward(velocity.x, 0, 5 * SPEED * delta)
		
	if Input.is_action_pressed("up"):
		velocity.y = -SPEED
		y_direction_input = "up"
		if not x_direction_input:
			override_direction_input = "up"
		last_direction = "up"
	elif Input.is_action_pressed("down"):
		velocity.y = SPEED
		y_direction_input = "down"
		if not x_direction_input:
			override_direction_input = "down"
		last_direction = "down"
	else:
		if y_direction_input == override_direction_input:
			y_direction_input = ""
			override_direction_input = x_direction_input
		velocity.y = move_toward(velocity.y, 0, 5 * SPEED * delta)
	
	if Input.is_action_pressed("space"): # *hidden "tech" for speedrunners included*
		if override_direction_input: # chooses the first input hit as the main direction
				if override_direction_input == "right" or override_direction_input == "left":
					velocity.x *= abs(sprite_position.y) / 9
				elif override_direction_input == "up" or override_direction_input == "down":
					velocity.y *= abs(sprite_position.y) / 9
		if sprite_position.y <= 0:
			change_sprite_2d_position(delta)
		else:
			if velocity.y != 0 and velocity.x != 0:
				if abs(velocity.y) < abs(velocity.x):
					velocity.x = abs(velocity.y) * (velocity.x / velocity.x)
				if abs(velocity.x) < abs(velocity.y):
					velocity.y = abs(velocity.x) * (velocity.y / velocity.y)
				
	else:
		sprite_position = sprite_position.move_toward(Vector2(0,0), 100 * delta)
		set_collision_mask_value(2,true)
	sprite_2d.position = sprite_position
	
	# self clamp because the normal clamp ain't working for me
	if velocity.y > SPEED * 3:
		velocity.y = SPEED * 3
	elif velocity.y < -SPEED * 3:
		velocity.y = -SPEED * 3
		
	if velocity.x > SPEED * 3:
		velocity.x = SPEED * 3
	elif velocity.x < -SPEED * 3:
		velocity.x = -SPEED * 3
	
	move_and_slide()

func change_sprite_2d_position(delta : float) -> void:
	if sprite_position.x == 0:
		sprite_position.y -= 75 * delta
	else:
		sprite_position.y += 10 * delta
	
	
	if sprite_position.y > 0:
		sprite_position.x = 0
	elif sprite_position.y < -23:
		sprite_position.x = 0.001
	
	if sprite_position.y < -11:
		set_collision_mask_value(2,false)
	else:
		set_collision_mask_value(2,true)
	
func _input(_event: InputEvent) -> void:
	
	
	if Input.is_action_pressed("space"):
		claws_hitbox.disabled = true
		return #prevents attacking while midair
	
	if Input.is_action_just_pressed("right-click"):
		#make projectile
		var instance = energy_projectile.instantiate()
		get_parent().add_child(instance)
		instance.position = position
		instance.set_collision_mask_value(3, true) #set to hit enemies
		instance.set_collision_mask_value(4, true) #enable hitting interactables
		
		
		var direction_input : String
		if override_direction_input:
			direction_input = override_direction_input
		else:
			direction_input = last_direction
		
		if direction_input == "right":
			instance.rotation = 0
			instance.velocity.x = SPEED*2
		elif direction_input == "left":
			instance.rotation = 0
			instance.velocity.x = -SPEED*2
		elif direction_input == "up":
			instance.rotation = PI/2
			instance.velocity.y = -SPEED*2
		elif direction_input == "down":
			instance.rotation = PI/2
			instance.velocity.y = SPEED*2
		
			
	claws_hitbox.disabled = true
	if Input.is_action_just_pressed("left-click"):
		claws_hitbox.disabled = false
		
		var direction_input : String
		if override_direction_input:
			direction_input = override_direction_input
		else:
			direction_input = last_direction
		
		if direction_input == "right":
			claws_hitbox.rotation = 0
			claws_hitbox.position = Vector2(30.75,0)
		elif direction_input == "left":
			claws_hitbox.rotation = 0
			claws_hitbox.position = Vector2(-30.75,0)
		elif direction_input == "up":
			claws_hitbox.rotation = PI/2
			claws_hitbox.position = Vector2(0,-30.75)
		elif direction_input == "down":
			claws_hitbox.rotation = PI/2
			claws_hitbox.position = Vector2(0,30.75)
		


func _on_claws_area_entered(area: Area2D) -> void:
	if not area.get_collision_layer_value(1): # is broken door, static body is on layer 1 not area
		area.queue_free()
	

func _on_claws_body_entered(body: Node2D) -> void:
	body.queue_free()
