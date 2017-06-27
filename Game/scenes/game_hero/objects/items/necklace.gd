extends Node2D

const attack = 1
const defense = 1
const cooldown = 0
const active = 0
const one_use = false
#var position

func _ready():
	pass

func attack():
	return attack

func defense():
	return defense

func is_one_use():
	return one_use

func cooldown():
	return cooldown

func active(current_room):
	return active

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("necklace", "items")
		queue_free()
