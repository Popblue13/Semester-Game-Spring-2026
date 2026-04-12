extends Node

var next_door_name: String = ""
var door_cooldown: float = 0.0
var player_abilities = {"boots" : false, "cannon" : false}

func _process(delta: float) -> void:
	if door_cooldown > 0.0:
		door_cooldown -= delta
		if door_cooldown < 0.0:
			door_cooldown = 0.0
