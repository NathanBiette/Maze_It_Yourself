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
	
func move_up():
	move(Vector2(0,-MOVEMENT_UNIT))
	if (is_colliding()):
		revert_motion()
		get_node("Movement_anims").play("blocked_move_up")
	else:
		get_node("Movement_anims").play("movement_up_50px")


func move_down():
	move(Vector2(0,MOVEMENT_UNIT))
	if (is_colliding()):
		revert_motion()
		get_node("Movement_anims").play("blocked_move_down")
	else:
		get_node("Movement_anims").play("movement_down_50px")


func move_left():
	move(Vector2(-MOVEMENT_UNIT,0))
	if (is_colliding()):
		revert_motion()
		get_node("Movement_anims").play("blocked_move_left")
	else:
		get_node("Movement_anims").play("movement_left_50px")

func move_right():
	move(Vector2(MOVEMENT_UNIT,0))
	if (is_colliding()):
		revert_motion()
		get_node("Movement_anims").play("blocked_move_right")
	else:
		get_node("Movement_anims").play("movement_right_50px")

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

func get_movement_unit():
	return MOVEMENT_UNIT