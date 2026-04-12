extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if get_child_count() > 1:
			print("You can press space to jump after you leave this room")
			Global.player_abilities["boots"] = true
			body.feature_enabled[0] = true
			#do boot stuff
		
		#do note stuff
		print("lore based on room")
		queue_free()
