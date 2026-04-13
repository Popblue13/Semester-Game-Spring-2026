extends CharacterBody2D

var health : float = 5
const SPEED = 300.0
var x_direction_input : String = ""
var y_direction_input : String = ""
var override_direction_input : String = ""
@onready var claws_hitbox: CollisionShape2D = $Claws/ClawsHitbox
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_hurtbox: CollisionShape2D = $PlayerHurtbox
@onready var sprite_position : Vector2 = Vector2(0,0)
@onready var animated_sprite_2d_2: AnimatedSprite2D = $Claws/ClawsHitbox/AnimatedSprite2D2
const energy_projectile : PackedScene = preload("res://Scenes/Dungeon Objects/energy_projectile.tscn")
var last_direction : String = "right"
var claw_cooldown : float = 0
var laser_charge_level : float = 0
var start_position : Vector2 
var feature_enabled : Array = [Global.player_abilities["boots"], 
Global.player_abilities["cannon"]] # boots, cannon, big claws
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var color_rect: ColorRect = $ColorRect

func _physics_process(delta: float) -> void:
	if position != Vector2(379.0, 241.0) and position != Vector2(0.0, 0.0) and not start_position:
		start_position = position
		
		
	if health <= 0:
		Global.deaths += 1
		if position == start_position:
			health = 5
			return
		position = start_position
		return
	elif health < 0.1:
		canvas_modulate.visible = true
		canvas_modulate.color = Color(1,0,1-2.5/health,health/5+0.5)
		health += delta/7.5
	else:
		canvas_modulate.visible = false
	color_rect.size.x = health * 8
		
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		x_direction_input = "right"
		if not y_direction_input:
			override_direction_input = "right"
		last_direction = "right"
		sprite_2d.play("Right")
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		x_direction_input = "left"
		if not y_direction_input:
			override_direction_input = "left"
		last_direction = "left"
		sprite_2d.play("Left")
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
		sprite_2d.play("Back")
	elif Input.is_action_pressed("down"):
		velocity.y = SPEED
		y_direction_input = "down"
		if not x_direction_input:
			override_direction_input = "down"
		last_direction = "down"
		sprite_2d.play("Front")
	else:
		if y_direction_input == override_direction_input:
			y_direction_input = ""
			override_direction_input = x_direction_input
		velocity.y = move_toward(velocity.y, 0, 5 * SPEED * delta)
	
	if Input.is_action_pressed("space") and feature_enabled[0]: 
		# *hidden "tech" for speedrunners included*
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
	
	# stuff for claws
	if Input.is_action_pressed("left-click"):
		if trigger_claw_cooldown(delta): # false if threshold reached
			claw_cooldown = 0
		claws_hitbox.disabled = false
		animated_sprite_2d_2.visible = true
	else:
		if trigger_claw_cooldown(delta*9):
			claws_hitbox.disabled = true
			animated_sprite_2d_2.visible = false
		else:
			claw_cooldown -= delta * 2
			
	# stuff for projectiles
	if Input.is_action_pressed("right-click") and feature_enabled[1]:
		if charging_projectile(delta):
			return
		laser_charge_level = 0
		#make projectile
		var instance = energy_projectile.instantiate()
		get_parent().add_child(instance)
		instance.position = position
		instance.set_collision_mask_value(3, true) #set to hit enemies
		instance.set_collision_mask_value(4, true) #enable hitting interactables
		
		
		var direction_input : String
		direction_input = last_direction
		
		if direction_input == "right":
			instance.rotation = 0
			instance.velocity.x = SPEED*2.5
		elif direction_input == "left":
			instance.rotation = 0
			instance.velocity.x = -SPEED*2.5
		elif direction_input == "up":
			instance.rotation = PI/2
			instance.velocity.y = -SPEED*2.5
		elif direction_input == "down":
			instance.rotation = PI/2
			instance.velocity.y = SPEED*2.5
	else:
		laser_charge_level = move_toward(laser_charge_level,1.5,delta)
			

func change_sprite_2d_position(delta : float) -> void:
	if sprite_position.x == 0:
		sprite_position.y -= 75 * delta # change how fast go up
	else:
		sprite_position.y += 10 * delta # fall speed
	
	
	if sprite_position.y > 0:
		sprite_position.x = 0
	elif sprite_position.y < -23: # make tinier to jump higher
		sprite_position.x = 0.001
	
	if sprite_position.y < -11:
		set_collision_mask_value(2,false)
	else:
		set_collision_mask_value(2,true)
	
func _input(_event: InputEvent) -> void:
	if is_queued_for_deletion():
		return
	
	if Input.is_action_pressed("space") and feature_enabled[0]:
		claws_hitbox.disabled = true
		return #prevents attacking while midair
			
	
	if Input.is_action_pressed("left-click"):
		var direction_input : String
		direction_input = last_direction
			
		if not claws_hitbox.disabled:
			if claw_cooldown > 2:
				claws_hitbox.scale = Vector2(1-2.0/3,1-2.0/3)
			else:
				claws_hitbox.scale = Vector2(1-claw_cooldown/3,1-claw_cooldown/3)
		else:
			claws_hitbox.scale = Vector2(1,1)
			
		if direction_input == "right":
			claws_hitbox.rotation = 0
			claws_hitbox.position = Vector2(24 *claws_hitbox.scale.x,0)
		elif direction_input == "left":
			claws_hitbox.rotation = 0 + PI
			claws_hitbox.position = Vector2(-24*claws_hitbox.scale.x,0)
		elif direction_input == "up":
			claws_hitbox.rotation = PI/2 + PI
			claws_hitbox.position = Vector2(0,-24*claws_hitbox.scale.y)
		elif direction_input == "down":
			claws_hitbox.rotation = PI/2
			claws_hitbox.position = Vector2(0,24*claws_hitbox.scale.y)
		
func trigger_claw_cooldown(delta: float) -> bool:
	claw_cooldown += delta
	if claw_cooldown > 5: # ten second threshold
		return true
	return false
	
func charging_projectile(delta: float) -> bool:
	laser_charge_level += delta
	if laser_charge_level > 1: # charging takes 2 seconds
		laser_charge_level = 10
		return false
	return true

func _on_claws_area_entered(area: Area2D) -> void:
	if not area.get_collision_layer_value(1): # is broken door, static body is on layer 1 not area
		area.queue_free()
	

func _on_claws_body_entered(body: Node2D) -> void:
	if not body.get_collision_layer_value(4): #not an interactable
		body.change_health(1)

func change_health(health_taken:float) -> void:
	health -= health_taken
