extends Area2D

## Scene this door loads when entered.
@export_file("*.tscn") var target_scene_path: String

## Name of the door in the destination scene to place the player at.
@export var target_door_name: String = ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	
	if Global.door_cooldown > 0.0:
		return
	
	if target_scene_path == "":
		push_warning("Door has no target scene path assigned.")
		return
	
	if target_door_name == "":
		push_warning("Door has no target_door_name assigned.")
		return
	
	Global.next_door_name = target_door_name
	Global.door_cooldown = 0.3
	get_tree().change_scene_to_file(target_scene_path)
