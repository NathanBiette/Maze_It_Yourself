extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("../.").initialize()