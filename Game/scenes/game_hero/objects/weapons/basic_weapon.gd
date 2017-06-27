extends Node2D

const attack = 1
#var position

func _ready():
	pass

func attack():
	return attack

func active(current_room):
	return 0

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("basic_weapon", "weapons")
		queue_free()
