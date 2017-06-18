extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var original_pos
const MOVEMENT_UNIT = 50

func _ready():
	original_pos = get_node(".").get_global_pos()
	# Called every time the node is added to the scene.
	# Initialization here

func interact(dir, node):
	if (dir=="up"):
		get_node("Sprite/Skeleton_Death_Anim").play("death")
		node.get_node("AnimatedSprite/Movement_anims").play("blocked_move_" + dir)
	else:
		node.lose_hp()

func _move(dir):
	if (dir=="up"):
		move(Vector2(0,-MOVEMENT_UNIT))
	elif (dir=="down"):
		move(Vector2(0,MOVEMENT_UNIT))
	elif (dir=="left"):
		move(Vector2(-MOVEMENT_UNIT,0))
	elif (dir=="right"):
		move(Vector2(MOVEMENT_UNIT,0))
	
	if (is_colliding()):
		revert_motion()

func _on_Timer_timeout():
	var dir = randi()%4+1
	if (dir==1):
		_move("up")
	if (dir==2):
		_move("down")
	if (dir==3):
		_move("left")
	if (dir==4):
		_move("right")


func _on_Skeleton_Death_Anim_finished():
	get_node(".").queue_free()
