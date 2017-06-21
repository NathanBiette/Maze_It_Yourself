extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var scene 
var node 
var h = 0

func _ready():
	scene = load("res://scenes/game_hero/objects/weapons/steel_sword.tscn")
	node = scene.instance()
	node.set_name("1")
	get_node("architect_floor").add_child(node)
	get_node("architect_floor/1").queue_free()
	node.free()

func new_instance(a, demanding_node):
	node = scene.instance()
	demanding_node.add_child(node)
	#node.free()


