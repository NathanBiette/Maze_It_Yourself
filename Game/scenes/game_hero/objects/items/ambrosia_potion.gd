extends Node2D

const attack = 0
const defense = 0
const one_use = true
const cooldown = 0
const active = 3
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
	current_room.get_node("../../theseus").invincibility = true
	return active

func active2(current_room):
	current_room.get_node("../../theseus").invincibility = false

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("ambrosia_potion", "items")
		queue_free()