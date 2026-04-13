extends Node2D


const SCRAP : PackedScene = preload("res://Scenes/Dungeon Objects/scrap_2.tscn")
var charge : float = 1
var stopped_scrap : RigidBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawner_timer(delta):
		var instance = SCRAP.instantiate()
		add_child(instance)
		instance.global_position = global_position

func spawner_timer(delta: float) -> bool:
	charge += delta
	if charge > 2: # ~4 seconds to charge
		charge = 0
		return true # is charged
	else:
		return false


func _on_stopper_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		body.set_sleeping(true)
		if stopped_scrap:
			stopped_scrap.queue_free()
		stopped_scrap = body
