extends Node2D

const defense = 1
const active = 0
const cooldown = 0
#var position

func _ready():
	pass

func defense():
	return defense

func active(current_room):
	return active

func cooldown():
	return cooldown

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("basic_helmet", "helmets")
		queue_free()