extends Area2D

@export_file("*.tscn") var target_scene_path: String
@export var target_spawn_name: String = ""

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
	
	Global.next_spawn_name = target_spawn_name
	Global.door_cooldown = 0.3
	get_tree().change_scene_to_file(target_scene_path)
