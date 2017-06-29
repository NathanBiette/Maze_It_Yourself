extends TileMap

func _ready():
	get_node("../.").initialize()
	if get_node("../../..").get_name() == "game_architect":
		pass
	else :
		var minotaur_scene = load("res://scenes/game_hero/enemies/minotaur.tscn")
		var minotaur = minotaur_scene.instance()
		minotaur.set_pos(Vector2(500,500))
		add_child(minotaur)
