extends Sprite

var original_pos

func wall_collision():
	return original_pos

func set_pos(position):
	original_pos = position

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
