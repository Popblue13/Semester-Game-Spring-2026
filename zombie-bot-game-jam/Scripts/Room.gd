extends Node2D

func _ready() -> void:
	if Global.next_door_name == "":
		return
	
	var player := get_node_or_null("Player")
	if player == null:
		push_warning("Player node not found.")
		return
	
	var target_door := find_child(Global.next_door_name, true, false)
	if target_door == null:
		push_warning("Door not found: " + Global.next_door_name)
		return
	
	player.global_position = target_door.global_position
