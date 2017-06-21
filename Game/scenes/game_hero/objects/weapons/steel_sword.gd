extends KinematicBody2D

const attack = 10
var position

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func interact(node):
	#interactions with lootable objects
	node.loot(get_node())
	#delete instance of lootable
	get_node(".").queue_free()

	#theseus plays his attack anim or loses HP
	node.set_idle(false)
	node.get_node("AnimatedSprite/Movement_anims").play("blocked_move_" + dir)
