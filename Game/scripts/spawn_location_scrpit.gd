extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var file = "res://scenes/game_architect/ghost_enemies/skeleton.tscn"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func get_file():
	return file
