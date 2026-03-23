extends Node2D

@export var default_spawn_path: NodePath

func _ready() -> void:
	var player := get_node_or_null("Player")
	if player == null:
		push_warning("Player node not found.")
		return

	# If we came from a door, place the player at that destination door.
	if Global.next_door_name != "":
		var target_door := find_child(Global.next_door_name, true, false)
		if target_door == null:
			push_warning("Door not found: " + Global.next_door_name)
			return

		var spawn_point := target_door.get_node_or_null("SpawnPoint")
		if spawn_point != null:
			player.global_position = spawn_point.global_position
		else:
			player.global_position = target_door.global_position

		# Clear it so future normal room loads do not reuse the old door.
		Global.next_door_name = ""
		return

	# Otherwise use the room's normal/default spawn.
	var default_spawn := get_node_or_null(default_spawn_path)
	if default_spawn != null:
		player.global_position = default_spawn.global_position
