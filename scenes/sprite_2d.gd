extends Sprite2D

@export var textures: Array[Texture2D] = []

func change_image(index: int) -> void:
	if index >= 0 and index < textures.size(): # size safety check
		texture = textures[index] # change the displaying texture to the choosen textures in the array
