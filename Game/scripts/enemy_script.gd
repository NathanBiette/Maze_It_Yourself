extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func interact():
	var collision_vector = get_collision_normal()
	if (collision_vector[1] > 0) :
		get_node(".").queue_free()

