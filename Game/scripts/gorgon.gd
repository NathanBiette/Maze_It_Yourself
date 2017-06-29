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
	damage = 1
	health = 5
	set_process(true)
	get_node("AnimatedSprite/TextureProgress").set_value((float(health)/float(5))*100.0)
	facing = "left"
	is_dead = false
	get_node("duration").set_active(false)
	get_node("cooldown").set_active(false)

func _process(delta):
	if (health <= 0):
		is_dead = true
		Globals.set("gold", Globals.get("gold") + gold)
		get_node("Particles2D").set_emitting(true)
		get_node("CollisionShape2D").queue_free()
		get_node("AnimatedSprite/AnimationPlayer").stop_all()
		get_node("AnimatedSprite/death_anim").play("death")
		get_node("SamplePlayer2D").play("death")
		set_process(false)

#fonction called when theseus collides with body from group enemies/traps 
#(dir: last input from hero; node: access to theseus functions)
func interact(dir, node):
	#interactions are specific to one enemy
	health -= node.attack
	get_node("AnimatedSprite/TextureProgress").set_value((float(health)/float(5))*100.0)
	node.get_node("AnimatedSprite/Blocked_move_anims").play("blocked_move_" + str(dir))

func act(dir):
	var theseus_pos = get_node("../../../../theseus").get_global_pos()
	if !is_dead:
		if (!get_node("cooldown").is_active() and ((abs(get_node(".").get_global_pos().x - theseus_pos.x)<400 and get_node(".").get_global_pos().y==theseus_pos.y) or (abs(get_node(".").get_global_pos().y - theseus_pos.y)<400 and get_node(".").get_global_pos().x==theseus_pos.x))):
			get_node("Timer").stop()
			petrify(dir)
		else:
			if (dir=="up"):
				move(Vector2(0,-movement_unit))
				get_node("AnimatedSprite").set_offset(Vector2(0,movement_unit))
				get_node("AnimatedSprite/AnimationPlayer").play("move_up")
			elif (dir=="down"):
				move(Vector2(0,movement_unit))
				get_node("AnimatedSprite").set_offset(Vector2(0,-movement_unit))
				get_node("AnimatedSprite/AnimationPlayer").play("move_down")
			elif (dir=="left"):
				move(Vector2(-movement_unit,0))
				get_node("AnimatedSprite").set_offset(Vector2(movement_unit,0))
				get_node("AnimatedSprite/AnimationPlayer").play("move_left")
			elif (dir=="right"):
				move(Vector2(movement_unit,0))
				get_node("AnimatedSprite").set_offset(Vector2(-movement_unit,0))
				get_node("AnimatedSprite/AnimationPlayer").play("move_right")
			if (is_colliding()):
				revert_motion()
				if(dir=="right"):
					get_node("AnimatedSprite/AnimationPlayer").play("attack_right")
				else:
					get_node("AnimatedSprite/AnimationPlayer").play("attack_left")
				var collider = get_collider()
				if (collider.is_in_group("theseus")):
					collider.lose_hp(damage)
		current_dir=dir



#one move every timer finished
func _on_Timer_timeout():
	var theseus_pos = get_node("../../../../theseus").get_global_pos() 
	var guideline = get_node(".").get_global_pos() - theseus_pos
	var angle = guideline.angle()
	if (angle < 0.785 and angle > -0.785) :
		act("up")
	if (angle <= -0.785 and angle >= -2.356):
		act("right")
	if (angle <= 2.356 and angle >= 0.785):
		act("left")
	if (angle < -2.356 or angle > 2.356) :
		act("down")


func set_pause(boolean):
	if(boolean):
		get_node("Timer").stop()
		set_process(false)
	else:
		get_node("Timer").start()
		if is_dead :
			pass
		else:
			set_process(true)

#loads automatically when death anim is over
func _on_death_anim_finished():
	get_node(".").queue_free()

func petrify(dir):
	current_dir = dir
	if dir == "right":
		get_node("AnimatedSprite/laugh_anim").play("laugh_right")
	else:
		get_node("AnimatedSprite/laugh_anim").play("laugh_left")
	get_node("SamplePlayer2D").play("laugh")

func _on_laugh_anim_finished():
	var theseus_pos = get_node("../../../../theseus").get_global_pos()
	var dx=(get_node(".").get_global_pos().x - theseus_pos.x)
	var dy = (get_node(".").get_global_pos().y - theseus_pos.y)
	get_node("SamplePlayer2D").play("petrify")
	if (current_dir == "right"):
		get_node("AnimatedSprite/petrif_anim").play("petrify_right")
		if(dx<0 and dx>-400 and dy==0):
			get_node("../../../../theseus").set_idle(false)
			get_node("../../../../theseus/AnimatedSprite").set_modulate(Color(0.5,0.5,0.5))
			get_node("../../../../theseus/AnimatedSprite/Movement_anims").stop(true)
			get_node("../../../../theseus/AnimatedSprite/Blocked_move_anims").stop(true)
			get_node("Timer").set_wait_time(0.5)
	else:
		get_node("AnimatedSprite/petrif_anim").play("petrify_left")
		if (current_dir == "left" and dx>0 and dx<400 and dy==0):
			get_node("../../../../theseus").set_idle(false)
			get_node("../../../../theseus/AnimatedSprite").set_modulate(Color(0.5,0.5,0.5))
			get_node("../../../../theseus/AnimatedSprite/Movement_anims").stop(true)
			get_node("../../../../theseus/AnimatedSprite/Blocked_move_anims").stop(true)
			get_node("Timer").set_wait_time(0.5)
		if (current_dir == "up" and dx==0 and dy<400 and dy>0):
			get_node("../../../../theseus").set_idle(false)
			get_node("../../../../theseus/AnimatedSprite").set_modulate(Color(0.5,0.5,0.5))
			get_node("../../../../theseus/AnimatedSprite/Movement_anims").stop(true)
			get_node("../../../../theseus/AnimatedSprite/Blocked_move_anims").stop(true)
			get_node("Timer").set_wait_time(0.5)
		if (current_dir == "down" and dx==0 and dy>-400 and dy<0):
			get_node("../../../../theseus").set_idle(false)
			get_node("../../../../theseus/AnimatedSprite").set_modulate(Color(0.5,0.5,0.5))
			get_node("../../../../theseus/AnimatedSprite/Movement_anims").stop(true)
			get_node("../../../../theseus/AnimatedSprite/Blocked_move_anims").stop(true)
			get_node("Timer").set_wait_time(0.5)
	get_node("duration").set_active(true)
	get_node("duration").start()
	get_node("cooldown").set_active(true)
	get_node("cooldown").start()



func _on_duration_timeout():
	get_node("duration").set_active(false)
	get_node("../../../../theseus").set_idle(true)
	get_node("../../../../theseus/AnimatedSprite").set_modulate(Color(1,1,1))
	get_node("Timer").set_wait_time(1)


func _on_cooldown_timeout():
	get_node("cooldown").set_active(false)


func _on_petrif_anim_finished():
	get_node("Timer").start()
	get_node("SamplePlayer2D").stop_all()

