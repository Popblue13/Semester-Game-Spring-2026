extends Node2D

@onready var static_body_2d: StaticBody2D = $StaticBody2D
var is_active : bool = true # change this one variable at start of game to set


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().append_cover(self)
	visible = is_active
	static_body_2d.set_collision_layer_value(1,is_active)

func toggle_door():
	visible = not visible
	static_body_2d.set_collision_layer_value(1,visible)
