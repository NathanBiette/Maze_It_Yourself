extends Node2D

const defense = 1
const active = 0
const cooldown = 0
const description = "Basic helmet\n\nDefense: 1\n\nThe most basic helmet for a hoplite"
#var position

var on_cooldown = false
var timer

func _ready():
	pass

func description():
	return description

func defense():
	return defense

func active(current_room):
	return active

func cooldown():
	return cooldown

func is_on_cooldown():
	return on_cooldown

func set_on_cooldown(on_cd):
	on_cooldown = on_cd

func set_timer(t):
	timer = t

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("basic_helmet", "helmets")
		queue_free()