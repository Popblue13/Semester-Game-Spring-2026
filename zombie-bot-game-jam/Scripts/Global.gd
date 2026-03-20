extends Node

## Name of the door to spawn at in the next room.
var next_door_name: String = ""

## Small cooldown to prevent instant re-trigger.
var door_cooldown: float = 0.0

func _process(delta: float) -> void:
	if door_cooldown > 0.0:
		door_cooldown -= delta
		if door_cooldown < 0.0:
			door_cooldown = 0.0
