extends KinematicBody2D

var original_pos
var current_room
var max_HP = 10
#items and hp and gold of theseus
var helmet
var weapon
var shield
var item
var current_HP
var gold

#is a movement animation over right now?
var idle = true

#how many pixels theseus must move per swipe
const MOVEMENT_UNIT = 100

func _ready():
	original_pos = get_node(".").get_global_pos()
	current_room = 0
	#load equipement data and hp
	current_HP = Globals.get("hp")
	helmet = Globals.get("helmet")
	weapon = Globals.get("weapon")
	shield = Globals.get("shield")
	item = Globals.get("item")
	gold = Globals.get("gold")
	get_node("Camera2D/hud/healthBar").set_value((float(current_HP)/float(max_HP))*100)
	get_node("Camera2D/hud/coinSprite/coinLabel").set_text(str(gold))
	get_node("Camera2D/hud/weaponPanel/Sprite").set_texture(load("res://textures/objects/weapons/steel_sword.tex"))
	get_node("Camera2D/hud/weaponPanel/weaponProgress").set_value(100)

#extract direction of swipe gesture and call move function according to direction
#new version of swipe move that allow non rectilign moves to be taken in account
func _on_swipe_gesture_swiped(gesture):
	if (is_idle()):
		var angle = gesture.get_direction_angle()
		if (angle < 0.785 and angle > -0.785) :
			_move("up")
		if (angle <= -0.785 and angle >= -2.356):
			_move("right")
		if (angle <= 2.356 and angle >= 0.785):
			_move("left")
		if (angle < -2.356 or angle > 2.356) :
			_move("down")

#move script of theseus
func _move(dir):
	
	#part called to move theseus
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
		var collider = get_collider()
		#part coding what happens with every kind of collider
		if (collider.is_in_group("enemies")) :
			revert_motion()
			collider.interact(dir, get_node("."))
		elif (collider.is_in_group("door")) :
			revert_motion()
			collider.shazaam()
		elif (collider.is_in_group("lootable")):
			idle = false
			collider.interact(get_node("."))
			get_node("AnimatedSprite/Movement_anims").play("movement_" + dir + "_" + str(MOVEMENT_UNIT) + "px")
		else :
			idle = false
			revert_motion()
			get_node("AnimatedSprite/Movement_anims").play("blocked_move_" + dir)
	else:
		idle = false
		get_node("AnimatedSprite/Movement_anims").play("movement_" + dir + "_" + str(MOVEMENT_UNIT) + "px")


#function that can be called by enemies to change Theseus' attributes
func lose_hp(damage):
	current_HP -= damage
	get_node("AnimatedSprite/Damage_anims").play("hp_lost")
	get_node("Camera2D/hud/healthBar").set_value((float(current_HP)/float(max_HP))*100.0)

#function with potential (meaning useless for now)
func get_movement_unit():
	return MOVEMENT_UNIT

#set back theseus to idle state when move is finished
func _on_Movement_anims_finished():
	idle = true

#test idle state of theseus
func is_idle():
	return idle

#set idle state of theseus
func set_idle(enable):
	idle = enable

#get the amount of hp of theseus
func get_HP():
	return Vector2(max_HP,current_HP)

func get_current_room():
	return current_room

func set_current_room(new_room):
	current_room = new_room