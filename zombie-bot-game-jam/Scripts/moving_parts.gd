extends Node2D


const SPEED : float = 400
var conveyors_running : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
