extends Node2D

const attack = 1
#var position

func _ready():
	pass
	

func attack():
	return attack


func _on_Area2D_area_enter(area):
	#print("trigger")
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		print("node say " + get_node(".").get_name())
		interacting_node.pick_up(get_node("."))
	#area.get_node("../").get_name() #=> get theseus node

