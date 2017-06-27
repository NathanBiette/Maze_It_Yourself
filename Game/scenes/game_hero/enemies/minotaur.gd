extends KinematicBody2D

var facing = "down"
var damage = 2
var health = 50
var gold = 100
var is_dead = false

func _ready():
	get_node("theseus_detection_ray").set_enabled(true)
	get_node("theseus_detection_ray").add_exception(self)
	get_node("theseus_detection_ray").add_exception(get_node(".."))

	get_node("attack_ray1").set_enabled(true)
	get_node("attack_ray1").add_exception(self)
	get_node("attack_ray1").add_exception(get_node(".."))

	get_node("attack_ray2").set_enabled(true)
	get_node("attack_ray2").add_exception(self)
	get_node("attack_ray2").add_exception(get_node(".."))

	get_node("AnimatedSprite/TextureProgress").set_value(100)

	set_process(true)

	next_action()

func _process(delta):
	if health <= 0:
		is_dead = true
		get_node("CollisionShape2D").queue_free()
		get_node("AnimatedSprite/Movement_anims").stop_all()
		get_node("AnimatedSprite/Death_anims").play("death_"+str(facing))
		set_process(false)

func interact(dir, node):
	#interactions are specific to one enemy
	health -= node.attack
	get_node("AnimatedSprite/TextureProgress").set_value((float(health)/float(50))*100)
	node.get_node("AnimatedSprite/Blocked_move_anims").play("blocked_move_" + str(dir))

func next_action():
	var theseus_pos = get_node("../../../../theseus").get_global_pos() 
	var guideline = get_node(".").get_global_pos() - theseus_pos
	var angle = guideline.angle()
	get_node("theseus_detection_ray").set_cast_to(-guideline.normalized() * 150)
	if get_node("theseus_detection_ray").is_colliding():
		#Minautor attacks
		if (angle < 0.785 and angle > -0.785) :
			#UP
			get_node("AnimatedSprite/Attack_anims_windup").play("attack_up_windup")
			facing = "up"
		if (angle <= -0.785 and angle >= -2.356):
			#RIGHT
			get_node("AnimatedSprite/Attack_anims_windup").play("attack_right_windup")
			facing = "right"
		if (angle <= 2.356 and angle >= 0.785):
			#LEFT
			get_node("AnimatedSprite/Attack_anims_windup").play("attack_left_windup")
			facing = "left"
		if (angle < -2.356 or angle > 2.356) :
			#DOWN
			get_node("AnimatedSprite/Attack_anims_windup").play("attack_down_windup")
			facing = "down"
	elif (get_node("theseus_detection_ray").get_cast_to().x == 0 or get_node("theseus_detection_ray").get_cast_to().y == 0):
		pass
	else:
		if (angle < 0.785 and angle > -0.785) :
			#UP
			move(Vector2(0,-200))
			get_node("AnimatedSprite").set_offset(Vector2(0,100))
			get_node("AnimatedSprite/Movement_anims").play("up_walk")
			facing = "up"
		if (angle <= -0.785 and angle >= -2.356):
			#RIGHT
			move(Vector2(200,0))
			get_node("AnimatedSprite").set_offset(Vector2(-100,0))
			get_node("AnimatedSprite/Movement_anims").play("right_walk")
			facing = "right"
		if (angle <= 2.356 and angle >= 0.785):
			#LEFT
			move(Vector2(-200,0))
			get_node("AnimatedSprite").set_offset(Vector2(100,0))
			get_node("AnimatedSprite/Movement_anims").play("left_walk")
			facing = "left"
		if (angle < -2.356 or angle > 2.356) :
			#DOWN
			move(Vector2(0,200))
			get_node("AnimatedSprite").set_offset(Vector2(0,-100))
			get_node("AnimatedSprite/Movement_anims").play("down_walk")
			facing = "down"

#================Movement=======================
func _on_Movement_anims_finished():
	next_action()

#=================Idle==========================



#================Basic attacks==================

func _on_Attack_anims_windup_finished():
	if facing == "up":
		get_node("attack_ray1").set_cast_to(Vector2(-50,-150))
		get_node("attack_ray2").set_cast_to(Vector2(50,-150))
	if facing == "left":
		get_node("attack_ray1").set_cast_to(Vector2(-150,50))
		get_node("attack_ray2").set_cast_to(Vector2(-150,-50))
	if facing == "down":
		get_node("attack_ray1").set_cast_to(Vector2(-50,150))
		get_node("attack_ray2").set_cast_to(Vector2(50,150))
	if facing == "right":
		get_node("attack_ray1").set_cast_to(Vector2(150,50))
		get_node("attack_ray2").set_cast_to(Vector2(150,-50))
	
	if (get_node("attack_ray1").is_colliding()):
		var collider = get_node("attack_ray1").get_collider()
		print(str(collider))
		if (collider.is_in_group("theseus")):
			collider.lose_hp(damage)
	elif get_node("attack_ray2").is_colliding():
		var collider = get_node("attack_ray2").get_collider()
		print(str(collider))
		if (collider.is_in_group("theseus")):
			collider.lose_hp(damage)
	get_node("AnimatedSprite/Attack_anims").play("attack_"+str(facing))

func _on_Attack_anims_finished():
	next_action()

#================Circular Strike==================

func _on_Circular_strike_windup_finished():
	get_node("AnimatedSprite/Circular_strike_anim").play("circular_strike")
	var theseus_pos = get_node("../../../../theseus").get_global_pos() 
	var guideline = get_node(".").get_global_pos() - theseus_pos
	if guideline.length() < 250:
		get_node("../../../../theseus").lose_hp(4)
