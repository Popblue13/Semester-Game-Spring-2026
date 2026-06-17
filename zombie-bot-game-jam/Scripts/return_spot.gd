extends Node2D

var player : CharacterBody2D
var battery_explode : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player and battery_explode:
		player.change_health(delta*15)


func _on_electric_field_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.get_collision_layer_value(2):
			player = body


func _on_energy_boxes_child_exiting_tree(_node: Node) -> void:
	battery_explode = true
	
	


func _on_electric_field_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.get_collision_layer_value(2):
			player = null
