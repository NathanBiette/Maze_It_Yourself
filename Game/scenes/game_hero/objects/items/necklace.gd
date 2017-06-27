extends Node2D

const attack = 1
const defense = 1
const cooldown = 0
const active = 0
const one_use = false
#var position

var on_cooldown = false
var timer

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

func is_on_cooldown():
	return on_cooldown

func set_on_cooldown(on_cd):
	on_cooldown = on_cd

func set_timer(t):
	timer = t

func active(current_room):
	return active

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("necklace", "items")
		queue_free()
