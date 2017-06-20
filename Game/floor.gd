extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const OFFSET = 5000
var current_room
var rooms = Array()
var doors = Array()
#vector2vector2array really
var links = Vector2Array()

var number_of_rooms = 0

func _ready():
	add_room("res://scenes/test_map.tscn")
	add_architect()
	current_room==rooms[0]

func add_architect():
	var scene = load("res://scenes/architect.tscn")
	var node = scene.instance()
	add_child(node)

func add_room(room):
	var scene = load(room)
	var node = scene.instance()
	add_child(node)
	#var temp_doors_location
	rooms.append(node)
	node.set_name("map_" + str(number_of_rooms))
	node.get_node("TileMap").set_global_pos(Vector2(OFFSET * number_of_rooms, 0))
	doors.append(node.get_doors_locations())
	create_doors(number_of_rooms)
	number_of_rooms += 1

func create_doors(active_room):
	# if you want only one door use this code instead
	#var scene = load("res://scenes/door.tscn")
	#var node = scene.instance()
	#add_child(node)
	#node.set_global_pos(Vector2(50,150))
	
	#finds all doors and put at these locations a square for TP
	for d in range(doors[active_room].size()):
		var scene = load("res://scenes/door.tscn")
		var node = scene.instance()
		get_node("map_" + str(number_of_rooms)).add_child(node)
		node.set_global_pos(Vector2((doors[active_room][d][0]*100 + 50) + OFFSET * number_of_rooms,(doors[active_room][d][1]*100 +50)))

func change_room(door):
	var movement = get_node("theseus").get_global_pos()
	movement[0]+=OFFSET * (number_of_rooms - 1)
	get_node("theseus").set_global_pos(movement)

func update_links(link, node):
	pass