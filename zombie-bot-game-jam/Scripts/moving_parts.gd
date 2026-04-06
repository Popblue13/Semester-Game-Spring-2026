extends Node2D


const SPEED : float = 400
var conveyors_running : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		child.set_collision_mask_value(4, true)

# controls children to enable or disable when conveyers are moving
func toggle_conveyor_movement() -> void:
	conveyors_running = not conveyors_running

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not conveyors_running: # prevents conveyors moving when we don't want them to
		return
	
	for shape_cast in get_children():
		if shape_cast.get_collision_count() != 0:
			if shape_cast.get_collider(0) is StaticBody2D:
				shape_cast.add_exception(shape_cast.get_collider(0))
			elif shape_cast.get_collider(0) is RigidBody2D:
				#if shape_cast.get_collider(0).get_linear_velocity() != Vector2(0,0):
				#	shape_cast.get_collider(0).set_linear_velocity(Vector2(0,0))
					
				if shape_cast.get_target_position().y != 0:
					shape_cast.get_collider(0).apply_impulse(Vector2(0,SPEED/4*
						shape_cast.get_target_position().y / abs(shape_cast.get_target_position().y)))
				elif shape_cast.get_target_position().x != 0:
					shape_cast.get_collider(0).apply_impulse(Vector2(SPEED/4*
						shape_cast.get_target_position().x / abs(shape_cast.get_target_position().x), 0))
				
				shape_cast.add_exception(shape_cast.get_collider(0))
			else:
				var mod_p : int = 1 # zombies get thrown at SPEED, player needs a lil extra
				if shape_cast.get_collider(0) == null or shape_cast.get_collider(0).is_queued_for_deletion():
					continue
				elif shape_cast.get_collider(0).get_collision_layer_value(2): #is player
					mod_p = 10
				
					
				if shape_cast.get_target_position().y != 0:
					shape_cast.get_collider(0).velocity.y += SPEED *mod_p*delta* (
						shape_cast.get_target_position().y / abs(shape_cast.get_target_position().y))
				elif shape_cast.get_target_position().x != 0:
					shape_cast.get_collider(0).velocity.x += SPEED *mod_p*delta* (
						shape_cast.get_target_position().x / abs(shape_cast.get_target_position().x))
