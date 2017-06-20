extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var current_room
#considering rooms are no longer than 4900 px
var offset = 5000
var rooms = Array()
var links = Array()
var doors = Array()
var theseus = Vector2(0,0)

func _ready():
	add_room("res://scenes/test_map.tscn")
	set_process(true)
	doors = rooms[0].get_doors_locations()
	current_room = rooms[0]
	
func add_room(room):
	var scene = load(room)
	var node = scene.instance()
	add_child(node)
	rooms.append(node)
	

func change_room(door):
	pass

func update_links(link, node):
	pass

#func _process(delta):
#	if(current_room.is_open()):
#		theseus = get_node("theseus").get_global_pos()
#		for i in range(doors.size()):
#			if (current_room.get_node("TileMap").get_cellv(theseus) == current_room.get_node("TileMap").get_cell(doors[i])):
#				load("res://scenes/test_map.tscn")
#			pass
	