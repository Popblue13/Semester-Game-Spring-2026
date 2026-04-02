extends Node2D
@export var room_theme: String = ""

func _ready() -> void:
	call_deferred("_place_player_at_door")
	if room_theme != "":
		MusicManager.play_theme(room_theme)
func _place_player_at_door() -> void:
	if Global.next_door_name == "":
		return
	
	var player := get_node_or_null("player")
	if player == null:
		push_warning("Player node not found.")
		return
	
	var target_door := find_child(Global.next_door_name, true, false)
	if target_door == null:
		push_warning("Door not found: " + Global.next_door_name)
		return
	
	player.global_position = target_door.global_position
	if player is CharacterBody2D:
		player.velocity = Vector2.ZERO
	
	Global.next_door_name = ""
