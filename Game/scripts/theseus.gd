extends KinematicBody2D

var original_pos
var hp = 5
var helmet = "default_helmet"
var weapon = "default_weapon"
var shield = "default_shield"
var item = "default_item"

#how many pixels theseus must move per swipe
const MOVEMENT_UNIT = 100

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
	
	#part called when colliding with wall, trap, enemy, object
	if (is_colliding()):
		revert_motion()
		var collider = get_collider()
		#part coding what happens with every kind of collider
		if (collider.is_in_group("enemies")) :
			collider.get_node(".").interact(dir, get_node("."))
		else :
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

#function that can be called by enemies to change Theseus' attributes
func lose_hp():
	get_node("AnimatedSprite/Movement_anims").play("hp_lost")

#function with potential (meaning useless for now)
func get_movement_unit():
	return MOVEMENT_UNIT