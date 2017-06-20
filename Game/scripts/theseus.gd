extends KinematicBody2D


##VARABLES##
var original_pos
var current_room
var max_HP = 10

#items
var helmet
var weapon
var shield
var item

#stats
var current_HP
var attack
var defense
var gold

#is a movement animation over right now?
var idle = true

#how many pixels theseus must move per swipe
const MOVEMENT_UNIT = 100

#storage variable to keep track of dropping object node before dropping object on next move
var dropping_object
var dropping = false


##FUNCTIONS##
func _ready():
	original_pos = get_node(".").get_global_pos()
	current_room = 0
	#load equipement data and hp
	current_HP = Globals.get("hp")
	#load et instance node from starter inventory
	helmet = load("res://scenes/game_hero/objects/helmets/" + str(Globals.get("helmet")) + ".tscn").instance()
	weapon = load("res://scenes/game_hero/objects/weapons/" + str(Globals.get("weapon")) + ".tscn").instance()
	shield = load("res://scenes/game_hero/objects/shields/" + str(Globals.get("shield")) + ".tscn").instance()
	item = load("res://scenes/game_hero/objects/items/" + str(Globals.get("item")) + ".tscn").instance()
	gold = Globals.get("gold")
	#compute attack and defense stats
	attack = weapon.attack()
	defense = shield.defense() + helmet.defense()
	#print( get_node("../floor/map_" + str(current_room)).get_filename())
	#print(weapon.get_name())

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
		#collision with door
		elif (collider.is_in_group("door")) :
			revert_motion()
			collider.shazaam()
		#collisition with loot
		elif (collider.is_in_group("lootable")):
			if(dropping):
				idle = false
				get_node("AnimatedSprite/Movement_anims").play("movement_" + dir + "_" + str(MOVEMENT_UNIT) + "px")
				drop(dropping_object, dir)
				loot(collider)
			else:
				idle = false
				get_node("AnimatedSprite/Movement_anims").play("movement_" + dir + "_" + str(MOVEMENT_UNIT) + "px")
				loot(collider)
		
		else :
			idle = false
			revert_motion()
			get_node("AnimatedSprite/Movement_anims").play("blocked_move_" + dir)
	else:
		if(dropping):
			idle = false
			get_node("AnimatedSprite/Movement_anims").play("movement_" + dir + "_" + str(MOVEMENT_UNIT) + "px")
			drop(dropping_object,dir)
		else:
			idle = false
			get_node("AnimatedSprite/Movement_anims").play("movement_" + dir + "_" + str(MOVEMENT_UNIT) + "px")


#function that can be called by enemies to change Theseus' attributes
func lose_hp(damage):
	current_HP -= damage
	get_node("AnimatedSprite/Damage_anims").play("hp_lost")

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
	
func loot(collider):
	if (collider.is_in_group("weapons")):
		dropping_object = weapon
		#set bool dropping to true to trigger drop action on next succesful move
		dropping = true
		#duplicate node of colliding item for it not to be destroyed on freeing from map
		weapon = collider.duplicate()
		#save weapon reference 
		Globals.set("weapon", weapon.get_name())
		#update stats
		stats_update()
		#destroy instance of collider in test map
		collider.queue_free()
#	elif (collider.is_in_group("shields")):
#		print("helle")
#	elif (collider.is_in_group("helmets")):
#		
#	elif (collider.is_in_group("items")):
		
	pass
	#collider.interact(get_node("."))

#dropping function
func drop(node, dir):
	#get position after!! move and compute position of drop (previous position of player) 
	var pos_of_drop = get_node(".").get_pos()
	if (dir=="up"):
		pos_of_drop[1] += MOVEMENT_UNIT
	elif (dir=="down"):
		pos_of_drop[1] -= MOVEMENT_UNIT
	elif (dir=="left"):
		pos_of_drop[0] += MOVEMENT_UNIT
	elif (dir=="right"):
		pos_of_drop[0] -= MOVEMENT_UNIT
	#set position of drop on the map
	node.set_pos(pos_of_drop)
	#add chil node to map
	get_node("../floor/map_" + str(current_room)).add_child(node.duplicate())
	#destroy instance of dropping object
	node.queue_free()
	dropping = false

#to update stats of hero
func stats_update():
	attack = weapon.attack()
	defense = shield.defense() + helmet.defense()