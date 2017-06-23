extends Node2D

const attack = 1
#var position

func _ready():
	pass

func attack():
	return attack

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("steel_sword", "weapons")
		get_node(".").get_parent().kill(get_node("."))

