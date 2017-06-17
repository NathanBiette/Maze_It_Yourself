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


func move_down():
	move(Vector2(0,MOVEMENT_UNIT))
	if (is_colliding()):
		revert_motion()


func move_left():
	move(Vector2(-MOVEMENT_UNIT,0))
	if (is_colliding()):
		revert_motion()

func move_right():
	move(Vector2(MOVEMENT_UNIT,0))
	if (is_colliding()):
		revert_motion()


func get_movement_unit():
	return MOVEMENT_UNIT


func _on_Timer_timeout():
	var dir = randi()%4+1
	if (dir==1):
		move_up()
	if (dir==2):
		move_down()
	if (dir==3):
		move_left()
	if (dir==4):
		move_right()
