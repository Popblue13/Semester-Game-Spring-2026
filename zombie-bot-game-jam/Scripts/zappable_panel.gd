extends Node2D

var door : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()
	if not door:
		return
	for i in len(door):
		door[i].toggle_door()

func append_cover(cover : Node2D):
	door.append(cover)
