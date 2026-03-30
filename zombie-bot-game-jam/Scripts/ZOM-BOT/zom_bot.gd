extends Node2D

@onready var head: CharacterBody2D = $Head
var started : bool = false
const ZOMBIE : PackedScene = preload("res://Scenes/Dungeon Objects/zombie.tscn")
const DRONE : PackedScene = preload("res://Scenes/Dungeon Objects/drone.tscn")
@onready var no_escape: StaticBody2D = $NoEscape

func initiate_battle(player : CharacterBody2D):
	for part in get_children():
		if part is not CharacterBody2D:
			continue
		else:
			set_target(part, player)

func set_target(part : CharacterBody2D, target : CharacterBody2D):
	part.target = target

func _on_yap_box_body_exited(body: Node2D) -> void:
	if started:
		return
	elif body.get_collision_layer_value(2):
		initiate_battle(body)
		started = true
		no_escape.set_collision_layer_value(1, true)


func _on_timer_timeout() -> void:
	var parts = get_children()
	parts.shuffle()
		
	for part in parts:
		if part is not CharacterBody2D:
			continue
		else:
			var instance = ZOMBIE.instantiate()
			get_parent().add_child(instance)
			instance.global_position = part.global_position
			break
