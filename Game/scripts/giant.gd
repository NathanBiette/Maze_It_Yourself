extends KinematicBody2D

const gold = 30

var original_pos
var damage
var movement_unit = 100
var health
var current_dir
var facing
var is_dead


func _ready():
	original_pos = get_node(".").get_global_pos()
	damage = 3
	health = 10
	set_process(true)
	get_node("AnimatedSprite/TextureProgress").set_value((float(health)/float(10))*100.0)
	facing = "left"
	is_dead = false
	get_node("RayCast2D").add_exception(get_node(".."))
	get_node("RayCast2D").add_exception(get_node("."))
	randomize()

func _process(delta):
	if (health <= 0):
		is_dead = false
		Globals.set("gold", Globals.get("gold") + gold)
		get_node("Particles2D").set_emitting(true)
		get_node("CollisionShape2D").queue_free()
		get_node("AnimatedSprite/Movement_anims").stop_all()
		get_node("AnimatedSprite/smash").stop_all()
		get_node("AnimatedSprite/Death_Anim").play("death")
		get_node("SamplePlayer2D").play("death")
		set_process(false)

#fonction called when theseus collides with body from group enemies/traps 
#(dir: last input from hero; node: access to theseus functions)
func interact(dir, node):
	#interactions are specific to one enemy
	health -= node.attack
	get_node("AnimatedSprite/TextureProgress").set_value((float(health)/float(10))*100.0)
	node.get_node("AnimatedSprite/Blocked_move_anims").play("blocked_move_" + str(dir))

func _move(dir):
	if !is_dead:
		if facing == "left":
			get_node("AnimatedSprite/Movement_anims").play("about_to_move")
			current_dir = dir
		elif facing == "right":
			get_node("AnimatedSprite/Movement_anims").play("about_to_move_right")
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
		facing = "right"
	if (angle <= 2.356 and angle >= 0.785):
		_move("left")
		facing = "left"
	if (angle < -2.356 or angle > 2.356) :
		_move("down")

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
		if is_dead:
			pass
		else:
			set_process(true)

func _on_Movement_anims_finished():
	advance(current_dir)
	var current_pos = get_pos()
	get_node("SamplePlayer2D").play("move")
	if (current_dir=="up"):
		get_node("RayCast2D").set_cast_to(Vector2(0,0))
	elif (current_dir=="down"):
		get_node("RayCast2D").set_cast_to(Vector2(0,0))
	elif (current_dir=="left"):
		get_node("RayCast2D").set_cast_to(Vector2(-200,0))
	elif (current_dir=="right"):
		get_node("RayCast2D").set_cast_to(Vector2(200,0))
	if get_node("RayCast2D").is_colliding():
		var collider = get_node("RayCast2D").get_collider()
		print(str(collider))
		if (collider.is_in_group("theseus")):
			collider.lose_hp(damage)
	
	if facing == "left":
		get_node("AnimatedSprite/smash").queue("smash")
	if facing == "right":
		get_node("AnimatedSprite/smash").queue("smash_right")

#loads automatically when death anim is over
func _on_Death_Anim_finished():
	get_node(".").queue_free()
