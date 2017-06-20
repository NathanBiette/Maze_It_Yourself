extends KinematicBody2D

const attack = 1
#var position

func _ready():
	pass
	
#func interact(node):
#	#interactions with lootable objects
#	node.loot(get_node())
#	#delete instance of lootable
#	get_node(".").queue_free()

func attack():
	return attack