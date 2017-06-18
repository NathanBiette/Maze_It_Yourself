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
		var stuff = get_collider()
		if (stuff.is_in_group("enemies")) :
			stuff.get_node(".").interact()
		else :
			revert_motion()
			get_node("AnimatedSprite/Movement_anims").play("blocked_move_" + dir)
	else:
		get_node("AnimatedSprite/Movement_anims").play("movement_" + dir + "_" + str(MOVEMENT_UNIT) + "px")

	#new version of swipe move that allow non rectilign moves to be taken in account
func _on_swipe_gesture_swiped( gesture ):
	var angle = gesture.get_direction_angle()
	if (angle < 0.785 and angle > -0.785) :
		_move("up")
	if (angle <= -0.785 and angle >= -2.356):
		_move("right")
	if (angle <= 2.356 and angle >= 0.785):
		_move("left")
	if (angle < -2.356 or angle > 2.356) :
		_move("down")
	
	

func get_movement_unit():
	return MOVEMENT_UNIT