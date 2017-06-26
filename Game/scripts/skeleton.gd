extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var original_pos
var damage
var movement_unit = 100
var health
var current_dir


func _ready():
	original_pos = get_node(".").get_global_pos()
	damage = 1
	health = 3
	set_process(true)
	get_node("Sprite/TextureProgress").set_value((float(health)/float(3))*100.0)

func _process(delta):
	if (health <= 0):
		get_node("CollisionShape2D").queue_free()
		get_node("Sprite/Death_Anim").play("death")
		set_process(false)

#fonction called when theseus collides with body from group enemies/traps 
#(dir: last input from hero; node: access to theseus functions)
func interact(dir, node):
	#interactions are specific to one enemy
	health -= node.attack
	get_node("Sprite/TextureProgress").set_value((float(health)/float(3))*100.0)
	node.get_node("AnimatedSprite/Movement_anims").play("blocked_move_" + str(dir))

func _move(dir):
	get_node("Sprite/Movement_anims").play("about_to_move")
	current_dir = dir

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

func advance(dir):
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

func set_pause(boolean):
	if(boolean):
		get_node("Timer").stop()
		set_process(false)
	else:
		get_node("Timer").start()
		set_process(true)

func _on_Movement_anims_finished():
	advance(current_dir)
