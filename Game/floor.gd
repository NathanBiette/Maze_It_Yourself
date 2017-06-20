extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var current_room
var rooms = Array()
var links = Array()

func _ready():
	add_room("res://scenes/test_map.tscn")
	current_room==rooms[0]
	
func add_room(room):
	var scene = load(room)
	var node = scene.instance()
	add_child(node)
	rooms.append(node)

func change_room(door):
	pass
func update_links(link, node):
	pass