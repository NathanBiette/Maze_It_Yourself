extends Node

var hero_position
var direction
var doors_locations
var is_open = false
var room_id = 0
const hero_speed = 50

func _ready():
	doors_locations = [Vector2(-1,-1),Vector2(-1,-1),Vector2(-1,-1),Vector2(-1,-1)]
	find_doors()
	close_doors()
	set_process(true)

func _process(delta):
	var tree = get_tree()
	if (no_enemy_left()):
		open_doors()


func open_doors():
	for d in range(doors_locations.size()):
		if (get_node("TileMap").get_cell(doors_locations[d][0],doors_locations[d][1])==1):
			get_node("TileMap").set_cell(doors_locations[d][0],doors_locations[d][1],2)
			#changes the cell just above the door /!\ doesn't work if the door is on a top or bottom wall
			get_node("TileMap").set_cell(doors_locations[d][0] ,doors_locations[d][1] -1 ,10)
		
		if (get_node("TileMap").get_cell(doors_locations[d][0],doors_locations[d][1])==5):
			get_node("TileMap").set_cell(doors_locations[d][0],doors_locations[d][1],6)
			#changes the cell just above the door /!\ doesn't work if the door is on a top or bottom wall
			get_node("TileMap").set_cell(doors_locations[d][0] ,doors_locations[d][1] -1 ,10)
	is_open = true

func close_doors():
	for d in range(doors_locations.size()):
		if (get_node("TileMap").get_cell(doors_locations[d][0],doors_locations[d][1])==2):
			get_node("TileMap").set_cell(doors_locations[d][0],doors_locations[d][1],1)

func find_doors():
	var tab = get_node("TileMap").get_used_cells()
	for t in range(tab.size()):
		if (get_node("TileMap").get_cell(tab[t][0],tab[t][1])==1 or get_node("TileMap").get_cell(tab[t][0],tab[t][1])==2 ):
			#EAST
			doors_locations[3] = tab[t]
		if (get_node("TileMap").get_cell(tab[t][0],tab[t][1])==3 or get_node("TileMap").get_cell(tab[t][0],tab[t][1])==4 ):
			#NORD
			doors_locations[0] = tab[t]
		if (get_node("TileMap").get_cell(tab[t][0],tab[t][1])==5 or get_node("TileMap").get_cell(tab[t][0],tab[t][1])==6 ):
			#WEST
			doors_locations[1] = tab[t]
		if (get_node("TileMap").get_cell(tab[t][0],tab[t][1])==7 or get_node("TileMap").get_cell(tab[t][0],tab[t][1])==8 ):
			#SOUTH
			doors_locations[2] = tab[t]

func update_global_pos(room_number):
	for i in doors_locations:
		i[0] += 50*room_number
	
func get_doors_locations():
	return doors_locations

func get_room_id():
	return room_id

func set_room_id(id):
	room_id = id

func is_open():
	return is_open
	
func no_enemy_left():
	var kids = get_node("TileMap").get_children()
	for kid in kids:
		if kid.is_in_group("enemies"):
			return false
	return true

func set_pause_room(boolean):
	var kids = get_node("TileMap").get_children()
	for kid in kids:
		if (kid.has_method("set_pause")):
			kid.set_pause(boolean)