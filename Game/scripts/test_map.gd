extends Node

var hero_position
var direction
var doors_locations
var is_open = false

const hero_speed = 50

func _ready():
	doors_locations = Vector2Array()
	find_doors()
	create_doors()
	close_doors()
	set_process(true)

func _process(delta):
	if (get_tree().get_nodes_in_group("enemies").size()==0):
		open_doors()


func open_doors():
	for d in range(doors_locations.size()):
		if (get_node("TileMap").get_cell(doors_locations[d][0],doors_locations[d][1])==2):
			get_node("TileMap").set_cell(doors_locations[d][0],doors_locations[d][1],3)
	is_open = true

func close_doors():
	for d in range(doors_locations.size()):
		if (get_node("TileMap").get_cell(doors_locations[d][0],doors_locations[d][1])==3):
			get_node("TileMap").set_cell(doors_locations[d][0],doors_locations[d][1],2)

func find_doors():
	var tab = get_node("TileMap").get_used_cells()
	for t in range(tab.size()):
		if (get_node("TileMap").get_cell(tab[t][0],tab[t][1])==3 or get_node("TileMap").get_cell(tab[t][0],tab[t][1])==2 ):
			doors_locations.append(tab[t])

func get_doors_locations():
	return doors_locations

func create_doors():
	var scene = load("res://scenes/door.tscn")
	var node = scene.instance()
	add_child(node)
	node.set_global_pos(Vector2(50,150))
	#for d in range(doors_locations.size()):
		#var scene = load("res://scenes/door.tscn")
		#var node = scene.instance()
		#add_child(node)
		#node.set_global_pos(Vector2((doors_locations[d][0]*100 +50),(doors_locations[d][1]*100 +50)))

func is_open():
	return is_open