extends Area2D

@export_file("*.tscn") var target_scene_path: String
@export var target_door_name: String = ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	
	if Global.door_cooldown > 0.0:
		return
	
	if target_scene_path == "" or target_door_name == "":
		return
	
	Global.next_door_name = target_door_name
	Global.door_cooldown = 0.3
	get_tree().change_scene_to_file(target_scene_path)
