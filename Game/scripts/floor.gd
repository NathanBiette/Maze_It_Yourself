extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const OFFSET = 5000
var rooms = Array()
#doors format : 
#	[[Vector2 global_pos, id [room number, door_type], id of connected door],[...],...]
var doors = Array()
#vector2vector2array really
var links = Vector2Array()
var number_of_rooms = 0

func _ready():
	add_room("res://scenes/game_hero/rooms/test_map.tscn")
	add_architect()
	get_node("map_"+str(get_node("../theseus").get_current_room())).set_pause_room(false)

func add_architect():
	var scene = load("res://scenes/game_architect/architect.tscn")
	var node = scene.instance()
	add_child(node)

func add_room(room):
	
	#creation of room
	var scene = load(room)
	var node = scene.instance()
	add_child(node)
	
	#setting up the room
	
	node.set_name("map_" + str(number_of_rooms))
	node.set_room_id(number_of_rooms)
	rooms.append(node)
	node.get_node("TileMap").set_global_pos(Vector2(OFFSET * number_of_rooms, 0))
	
	#managing doors
	
	var temp_doors_locations = node.get_doors_locations()
	for i in range(4):
		if (temp_doors_locations[i] == Vector2(-1,-1)):
			pass
		else:
			doors.append([Vector2((temp_doors_locations[i][0] + (50 * number_of_rooms)) * 100 + 50,temp_doors_locations[i][1] * 100 + 50),[node.get_room_id(), i],[-1,-1]])
	create_doors(number_of_rooms)
	
	#connecting 2 doors
	if (number_of_rooms >= 1):
		var random_door_id_1 = [0,3]
		var random_door_id_2 = [1,1]
		connect(random_door_id_1, random_door_id_2)
		
	#updating for next_use
	number_of_rooms += 1
	node.set_pause_room(true)

func create_doors(active_room):
	# if you want only one door use this code instead
	#var scene = load("res://scenes/door.tscn")
	#var node = scene.instance()
	#add_child(node)
	#node.set_global_pos(Vector2(50,150))
	
	#finds all doors in the the room and put at these locations a square for TP
	
	var doors_to_set = find_doors_in_room(active_room)
	for d in doors_to_set:
		var scene = load("res://scenes/game_hero/rooms/door.tscn")
		var node = scene.instance()
		get_node("map_" + str(number_of_rooms)).add_child(node)
		node.set_door_id(d[1][0],d[1][1])
		node.set_global_pos(d[0])

func change_room(door_id):
	var current_door_index = find_door_index(door_id)
	var next_door_id = doors[current_door_index][2]
	var next_door_index = find_door_index(next_door_id) 
	if (next_door_id == [-1,-1]):
		pass
	#NORTH CASE
	elif (next_door_id[1] == 0):
		get_node("../theseus").set_global_pos(Vector2(doors[next_door_index][0][0], doors[next_door_index][0][1] + 100))
		get_node("../theseus").set_current_room(next_door_id[0])
	#WEST CASE
	elif (next_door_id[1] == 1):
		get_node("../theseus").set_global_pos(Vector2(doors[next_door_index][0][0] + 100, doors[next_door_index][0][1]))
		get_node("../theseus").set_current_room(next_door_id[0])
	#SOUTH CASE
	elif (next_door_id[1] == 2):
		get_node("../theseus").set_global_pos(Vector2(doors[next_door_index][0][0], doors[next_door_index][0][1] - 100))
		get_node("../theseus").set_current_room(next_door_id[0])
	#EAST CASE
	elif (next_door_id[1] == 3):
		get_node("../theseus").set_global_pos(Vector2(doors[next_door_index][0][0] - 100, doors[next_door_index][0][1]))
		get_node("../theseus").set_current_room(next_door_id[0])

func find_doors_in_room(x):
	var l = []
	for d in doors:
		if (d[1][0] == x):
			l.append(d)
	return l

func get_my_door(door_id):
	return doors[find_door_index(door_id)][2]

func find_door_index(id):
	for i in range(doors.size()):
		if (doors[i][1] == id):
			return i

func connect(door_id1,door_id2):
	var i = find_door_index(door_id1)
	var j = find_door_index(door_id2)
	doors[i][2] = door_id2
	doors[j][2] = door_id1