extends Node


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

#to implement 
func change_room(door):
	pass

#to implement
func update_links(link, node):
	pass