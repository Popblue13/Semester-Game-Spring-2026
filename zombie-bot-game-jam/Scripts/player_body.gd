extends CharacterBody2D


const SPEED = 300.0
var x_direction_input : String = ""
var y_direction_input : String = ""
var override_direction_input : String = ""
@onready var claws_hitbox: CollisionShape2D = $Claws/ClawsHitbox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_hurtbox: CollisionShape2D = $PlayerHurtbox
@onready var sprite_position : Vector2 = Vector2(0,0)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		x_direction_input = "right"
		if not y_direction_input:
			override_direction_input = "right"
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		x_direction_input = "left"
		if not y_direction_input:
			override_direction_input = "left"
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
	elif Input.is_action_pressed("down"):
		velocity.y = SPEED
		y_direction_input = "down"
		if not x_direction_input:
			override_direction_input = "down"
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
		player_hurtbox.disabled = false
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
		player_hurtbox.disabled = true
	else:
		player_hurtbox.disabled = false
	
func _input(_event: InputEvent) -> void:
	claws_hitbox.disabled = true
	
	if Input.is_action_pressed("space"):
		return #prevents attacking while midair
	
	if Input.is_action_just_pressed("right-click"):
		pass
	
	if Input.is_action_just_pressed("left-click"):
		claws_hitbox.disabled = false
		if override_direction_input == "right":
			claws_hitbox.rotation = 0
			claws_hitbox.position = Vector2(23,0)
		elif override_direction_input == "left":
			claws_hitbox.rotation = 0
			claws_hitbox.position = Vector2(-23,0)
		elif override_direction_input == "up":
			claws_hitbox.rotation = PI/2
			claws_hitbox.position = Vector2(0,-23)
		elif override_direction_input == "down":
			claws_hitbox.rotation = PI/2
			claws_hitbox.position = Vector2(0,23)
		
