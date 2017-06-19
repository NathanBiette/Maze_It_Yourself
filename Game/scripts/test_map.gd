extends Node

var hero_position
var direction

const hero_speed = 50

func _ready():
	set_process(true)

func _process(delta):
	if (get_tree().get_nodes_in_group("enemies").size()==0):
		var tab = get_node("TileMap").get_used_cells()
		for t in range(tab.size()):
			if (get_node("TileMap").get_cell(tab[t][0],tab[t][1])==2):
				get_node("TileMap").set_cell(tab[t][0],tab[t][1],0)
			if (get_node("TileMap").get_cell(tab[t][0],tab[t][1])==6):
				get_node("TileMap").set_cell(tab[t][0],tab[t][1],5)

func get_HP():
	return get_node("theseus").get_HP()