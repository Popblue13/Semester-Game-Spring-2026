extends Node

var next_door_name: String = ""
var door_cooldown: float = 0.0
var player_abilities = {"boots" : false, "cannon" : false}
var deaths : int = 0

func _process(delta: float) -> void:
	print(Time.get_ticks_msec())
	if door_cooldown > 0.0:
		door_cooldown -= delta
		if door_cooldown < 0.0:
			door_cooldown = 0.0
