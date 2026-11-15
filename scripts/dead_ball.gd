extends StaticBody2D

func create_clone(sprite_pointer: int, corpse_position: Vector2) -> void:
	var clone = duplicate()
	
	# 1. Remove the spawner group so clones don't duplicate themselves!
	clone.remove_from_group("dead_ball")
	
	# 2. Add a separate group for the ball's floor raycast to detect
	clone.add_to_group("corpse_platform")
	
	get_parent().add_child(clone)
	
	clone.position = corpse_position
	
	var sprite = clone.get_node("Sprite2D")
	sprite.change_image(sprite_pointer)
	
	clone.visible = true
