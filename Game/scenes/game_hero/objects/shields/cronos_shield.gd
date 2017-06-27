extends Node2D

const defense = 1
const cooldown = 10
const active = 3
var timeStopped = false
#var position

var timer

func _ready():
	pass

func defense():
	return defense

func cooldown():
	return cooldown

func active(current_room):
	current_room.set_pause_room(true)
	return active

func active2(current_room):
	current_room.set_pause_room(false)

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("cronos_shield", "shields")
		queue_free()

func _on_timer_timeout():
	print("Hello")