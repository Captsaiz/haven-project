extends Sprite2D

var textures: Array[Texture2D] = [ # switch to preload cuz godot is being a meany
	preload("res://assets/Player Sprites/Normal_Corpse.png"),
	preload("res://assets/Player Sprites/Bouncy_Corpse.png"),
	preload("res://assets/Player Sprites/Speedy_Corpse.png")
]

var current_costume: int = 0

func change_image(index: int) -> void:
	print(textures.size())
	print(index)
	if index >= 0 and index < textures.size():
		current_costume = index
		texture = textures[index]
	else:
		print("Kodenya juga rusaj")
