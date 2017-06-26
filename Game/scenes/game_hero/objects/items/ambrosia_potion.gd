extends Node2D

const attack = 0
const defense = 0
#var position

func _ready():
	pass

func attack():
	return attack

func defense():
	return defense

func active(current_room):
	current_room.get_node("../../theseus").invincibility = true
	return 3

func active2(current_room):
	current_room.get_node("../../theseus").invincibility = false

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("ambrosia_potion", "items")
		queue_free()