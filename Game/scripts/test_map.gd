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
	if (get_node(".").get_tree().get_nodes_in_group("enemies").size()==0):
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
			#EST
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

func get_doors_locations():
	return doors_locations

func get_room_id():
	return room_id

func set_room_id(id):
	room_id = id

func is_open():
	return is_open

################LOOT#############################

#free the node when is idling
func kill(node_to_be_freed):
	node_to_be_freed.queue_free()

#add object to map (for drop)
func add_object(object_name, object_type, object_pos):
	print("res://scenes/game_hero/objects/"+object_type+"/"+object_name+".tscn")
	var object = load("res://scenes/game_hero/objects/"+object_type+"/"+object_name+".tscn").instance()
	object.set_pos(object_pos)
	get_node(".").add_child(object)

##################################################