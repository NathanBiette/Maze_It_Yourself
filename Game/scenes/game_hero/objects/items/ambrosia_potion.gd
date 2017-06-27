extends Node2D

const attack = 0
const defense = 0
const one_use = true
const cooldown = 0
const active = 3
const description = "Ambrosia potion\n\nActive effect: Makes you invincible for 3 seconds\n\nThe God's beverage. It is told to cure every disease."
#var position

var on_cooldown = false
var timer

func _ready():
	pass

func description():
	return description

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
	current_room.get_node("../../theseus").invincibility = true
	return active

func active2(current_room):
	current_room.get_node("../../theseus").invincibility = false

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("ambrosia_potion", "items")
		queue_free()