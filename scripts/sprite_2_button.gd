extends Button

@onready var Sprite2D_the_ball: Sprite2D = $"../../../the_ball/Sprite2D"


func _on_button_down() -> void:
	Sprite2D_the_ball.change_image(2)
	
	
