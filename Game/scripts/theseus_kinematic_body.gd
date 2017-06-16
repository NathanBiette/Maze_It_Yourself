extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var original_pos

func _ready():
	original_pos = get_node(".").get_global_pos()
	# Called every time the node is added to the scene.
	# Initialization here
	
func move_up():
	move(Vector2(0,-60))
	#if (is_colliding()):
	#	revert_motion()


func move_down():
	move(Vector2(0,50))
	#get_node("Movement_down").play("movement_down")
	if (is_colliding()):
		revert_motion()


func move_left():
	move(Vector2(-50,0))
	if (is_colliding()):
		revert_motion()

func move_right():
	move(Vector2(50,0))
	if (is_colliding()):
		revert_motion()

func _on_swipe_gesture_swiped( gesture ):
	var dir = gesture.get_direction()
	if (dir=="up"):
		move_up()
	if (dir=="down"):
		move_down()
	if (dir=="left"):
		move_left()
	if (dir=="right"):
		move_right()