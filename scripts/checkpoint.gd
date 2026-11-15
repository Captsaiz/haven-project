extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("the_ball"):
		body.SPAWN_POSITION = global_position
		
		Global.ui_visible = true
		
		print(Global.ui_visible)
		
		print("dan")


func _on_body_exited(body: Node2D) -> void:
	Global.ui_visible = false
	
	print(Global.ui_visible)
	
	print("dan")
