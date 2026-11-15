extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("the_ball"):
		body.SPAWN_POSITION = global_position
		
		print("dan")
