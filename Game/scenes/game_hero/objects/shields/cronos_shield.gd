extends Node2D

const defense = 1
const cooldown = 10
const active = 3
const description = "Cronos shieldDefense: 1\nActive effect: Stops time for 3 seconds (10 secs cooldown)\n\nThe shield of Cronos, the ancient titan of time. It holds a fragment of Cronos' time powers."
var timeStopped = false
#var position

var on_cooldown = false
var timer

func _ready():
	pass

func description():
	return description

func defense():
	return defense

func cooldown():
	return cooldown

func is_on_cooldown():
	return on_cooldown

func set_on_cooldown(on_cd):
	on_cooldown = on_cd

func set_timer(t):
	timer = t

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