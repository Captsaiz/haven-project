extends Area2D
@onready var Anim = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	var ball_inside := false
	Anim.play("default")
	for body in get_overlapping_bodies():
		if body.is_in_group("the_ball"):
			ball_inside = true
			body.SPAWN_POSITION = global_position
			break
	
	if ball_inside:
		Global.active_checkpoint = self
		Global.ui_visible = true
	elif Global.active_checkpoint == self:
		Global.active_checkpoint = null
		Global.ui_visible = false
