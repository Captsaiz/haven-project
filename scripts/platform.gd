extends CollisionShape2D


func _on_static_body_2d_ready() -> void:
	# Share the world Y position globally
	Global.platform_y = global_position.y
