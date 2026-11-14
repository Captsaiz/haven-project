extends Sprite2D

@export var textures: Array[Texture2D] = []
var current_costume: int = 0 # global global global variable beloved

func change_image(index: int) -> void:
	if index >= 0 and index < textures.size(): # size safety check
		
		current_costume = index
		texture = textures[index] # change the displaying texture to the choosen textures in the array
	
	else:
		print("Kodenya rusak wok :(")
