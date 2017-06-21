extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const OFFSET = 5000
var current_room
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
	current_room==rooms[0]

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
			doors.append([Vector2(temp_doors_locations[i][0] * 100 + 50,temp_doors_locations[i][1] * 100 + 50),[node.get_room_id(), i],[-1,-1]])
	create_doors(number_of_rooms)
	
	#updating for next_use
	number_of_rooms += 1

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
		node.set_global_pos(Vector2(d[0][0] + (OFFSET * d[1][0]),d[0][1]))

func change_room(door):
	var movement = get_node("../theseus").get_global_pos()
	var current_room = get_node("../theseus").get_current_room()
	movement[0]+= OFFSET * (number_of_rooms - current_room - 1)
	get_node("../theseus").set_global_pos(movement)
	get_node("../theseus").set_current_room(current_room + 1)

func find_doors_in_room(x):
	var l = []
	for d in doors:
		if (d[1][0] == x):
			l.append(d)
	return l

func find_door_id(id):
	for d in doors:
		if (d[1] == id):
			return d

func update_links(link, node):
	pass