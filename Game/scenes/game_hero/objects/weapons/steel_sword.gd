extends Node2D

const attack = 2
const cooldown = 0
const active = 0
const description = "Steel swordAttack: 2\n\nA sword forged in the blazing fire of Tartaros, the land of the deads."
#var position

var on_cooldown = false
var timer

func _ready():
	pass

func description():
	return description

func attack():
	return attack

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
		interacting_node.pick_up("steel_sword", "weapons")
		queue_free()

