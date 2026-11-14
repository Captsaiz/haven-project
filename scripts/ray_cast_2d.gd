extends RayCast2D

# Lock the ray from spinning
func _physics_process(_delta: float) -> void:
	global_rotation = 0.0
