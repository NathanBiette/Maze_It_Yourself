extends TileMap

func _ready():
	get_node("../.").initialize()
	get_node("../.").set_as_boss_room()
	var minotaur_scene = load("res://game_hero/enemies/minotaur.tscn")
	var minotaur = minotaur_scene.instance()
	minotaur.set_pos(Vector2(500,500))
