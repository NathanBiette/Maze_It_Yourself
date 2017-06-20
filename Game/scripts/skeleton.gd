extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var original_pos
var damage
var movement_unit = 100


func _ready():
	original_pos = get_node(".").get_global_pos()
	damage = 1
	# Called every time the node is added to the scene.
	# Initialization here

#fonction called when theseus collides with body from group enemies/traps 
#(dir: last input from hero; node: access to theseus functions)
func interact(dir, node):
	#interactions are specific to one enemy
	if (dir=="up"):
		get_node("Sprite/Skeleton_Death_Anim").play("death")
		#finishing an animation from the group death_anims deletes the skeleton node
		get_node("CollisionShape2D").queue_free()
		#the hitbox disapears first
		#theseus plays his attack anim or loses HP
		node.set_idle(false)
		node.get_node("AnimatedSprite/Movement_anims").play("blocked_move_" + dir)
	else:
		node.lose_hp(damage)

func _move(dir):
	if (dir=="up"):
		move(Vector2(0,-movement_unit))
	elif (dir=="down"):
		move(Vector2(0,movement_unit))
	elif (dir=="left"):
		move(Vector2(-movement_unit,0))
	elif (dir=="right"):
		move(Vector2(movement_unit,0))
	
	#part called when colliding with wall, other enemy or theseus
	if (is_colliding()):
		revert_motion()
		var collider = get_collider()
		if (collider.is_in_group("theseus")):
			collider.lose_hp(damage)

#one move every timer finished
func _on_Timer_timeout():
	var theseus_pos = get_node("../../../../theseus").get_global_pos() 
	var guideline = get_node(".").get_global_pos() - theseus_pos
	var angle = guideline.angle()
	if (angle < 0.785 and angle > -0.785) :
		_move("up")
	if (angle <= -0.785 and angle >= -2.356):
		_move("right")
	if (angle <= 2.356 and angle >= 0.785):
		_move("left")
	if (angle < -2.356 or angle > 2.356) :
		_move("down")

#loads automatically when death anim is over
func _on_Skeleton_Death_Anim_finished():
	get_node(".").queue_free()

func set_pause(boolean):
	if(boolean):
		get_node("Timer").stop()
		set_process(false)
	else:
		get_node("Timer").start()
		set_process(true)