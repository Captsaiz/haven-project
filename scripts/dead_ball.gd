extends StaticBody2D

func create_clone(sprite_pointer: int, corpse_position: Vector2) -> void:

	var clone = duplicate()
	get_parent().add_child(clone)
	
	print("Spawning corpse!")
	clone.position = corpse_position
	
	var sprite = clone.get_node("Sprite2D")
	
	print("Attached script: ", sprite.get_script())
	
	push_error(sprite_pointer)
	sprite.change_image(sprite_pointer)
	
	
	
	clone.visible = true
