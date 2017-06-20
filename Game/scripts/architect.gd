extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var next_room

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	next_room = "res://scenes/test_map.tscn"
	set_process(true)

func _process(delta):
	pass

func _on_Button_pressed():
	get_node("../.").add_room(next_room)


func _on_Button_2_pressed():
	pass # replace with function body
