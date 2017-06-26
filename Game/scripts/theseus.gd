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

var invincibility = false

#is a movement animation over right now?
var idle = true

#is game over now ?
var game_over = false

#how many pixels theseus must move per swipe
const MOVEMENT_UNIT = 100

#storage variable to keep track of dropping object node before dropping object on next move
var dropping_object_name
var dropping_object_type
var looting_object_name
var looting_object_type
var dropping = false
var looting = false
var previous_dir


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

	get_node("Camera2D/hud/healthBar").set_value((float(current_HP)/float(max_HP))*100)
	get_node("Camera2D/hud/coinSprite/coinLabel").set_text(str(gold))
	get_node("Camera2D/hud/weaponPanel/Sprite").set_texture(load("res://textures/objects/weapons/"+weapon.get_name()+".tex"))
	get_node("Camera2D/hud/helmetPanel/Sprite").set_texture(load("res://textures/objects/helmets/"+helmet.get_name()+".tex"))
	get_node("Camera2D/hud/shieldPanel/Sprite").set_texture(load("res://textures/objects/shields/"+shield.get_name()+".tex"))
	get_node("Camera2D/hud/weaponPanel/weaponProgress").set_value(100)

#move script of theseus
func _move(dir):
	#part called to move theseus
	if idle:
		if (dir=="up"):
			move(Vector2(0,-MOVEMENT_UNIT))
			idle = false
		elif (dir=="down"):
			move(Vector2(0,MOVEMENT_UNIT))
			idle = false
		elif (dir=="left"):
			move(Vector2(-MOVEMENT_UNIT,0))
			idle = false
		elif (dir=="right"):
			move(Vector2(MOVEMENT_UNIT,0))
			idle = false
		previous_dir = dir
		#part called when colliding with wall, trap, enemy, object
		if (is_colliding()):
			var collider = get_collider()
			#part coding what happens with every kind of collider
			if (collider.is_in_group("enemies")) :
				idle = false
				revert_motion()
				collider.interact(dir, get_node("."))
			#collision with door
			elif (collider.is_in_group("door")) :
				revert_motion()
				collider.shazaam()
				get_node("AnimatedSprite/Blocked_move_anims").queue("blocked_move_" + dir)
			else :
				idle = false
				revert_motion()
				get_node("AnimatedSprite/Blocked_move_anims").queue("blocked_move_" + dir)
		else:
			idle = false
			get_node("AnimatedSprite/Movement_anims").queue("movement_" + dir + "_" + str(MOVEMENT_UNIT) + "px")

		
#function that can be called by enemies to change Theseus' attributes
func lose_hp(damage):
	if !invincibility:
		current_HP -= damage
		print(current_HP)
		get_node("AnimatedSprite/Damage_anims").play("hp_lost")
		get_node("Camera2D/hud/healthBar").set_value((float(current_HP)/float(max_HP))*100.0)
		if (current_HP <= 0):
			game_over()

#function with potential (meaning useless for now)
func get_movement_unit():
	return MOVEMENT_UNIT

#set back theseus to idle state when move is finished
func _on_Movement_anims_finished():
	idle = true
	if(looting or dropping):
		update_inventory(previous_dir)

#get the amount of hp of theseus
func get_HP():
	return Vector2(max_HP,current_HP)

func get_current_room():
	return current_room

func set_current_room(new_room):
	current_room = new_room


############################LOOT##################################

func pick_up(object_name, object_type):
	looting_object_name = object_name
	looting_object_type = object_type
	print("pick_up " + looting_object_name)
	looting = true
	print(looting)
	

func update_inventory(dir):
	if(dropping):
		drop(dropping_object_name,dropping_object_type,dir)
	if (looting):
		loot(looting_object_name, looting_object_type)
		looting = false
		dropping = true
	#update stats of theseus
	stats_update()

func loot(looting_object_name,looting_object_type):
	if (looting_object_type == "weapons"):
			dropping_object_name = weapon.get_name()
			dropping_object_type = "weapons"
			#free previous weapon node before using weapon var again to store new weapon
			#weapon.queue_free()
			#load node of colliding item for it not to be destroyed on freeing from map
			weapon = load("res://scenes/game_hero/objects/"+looting_object_type+"/"+looting_object_name+".tscn").instance()
			get_node("Camera2D/hud/weaponPanel/Sprite").set_texture(load("res://textures/objects/weapons/"+weapon.get_name()+".tex"))
			#save weapon reference 
			Globals.set("weapon", weapon.get_name())
	if (looting_object_type == "shields"):
			dropping_object_name = shield.get_name()
			dropping_object_type = "shields"
			#shield.queue_free()
			shield = load("res://scenes/game_hero/objects/"+looting_object_type+"/"+looting_object_name+".tscn").instance()
			get_node("Camera2D/hud/shieldPanel/Sprite").set_texture(load("res://textures/objects/shields/"+shield.get_name()+".tex"))
			Globals.set("shield", helmet.get_name())
	if (looting_object_type == "helmets"):
			dropping_object_name = helmet.get_name()
			dropping_object_type = "helmets"
			#helmet.queue_free()
			helmet = load("res://scenes/game_hero/objects/"+looting_object_type+"/"+looting_object_name+".tscn").instance()
			get_node("Camera2D/hud/helmetPanel/Sprite").set_texture(load("res://textures/objects/helmets/"+helmet.get_name()+".tex"))
			Globals.set("helmet", helmet.get_name())
	if (looting_object_type == "items"):
			dropping_object_name = item.get_name()
			dropping_object_type = "items"
			#items.queue_free()
			item = load("res://scenes/game_hero/objects/"+looting_object_type+"/"+looting_object_name+".tscn").instance()
			get_node("Camera2D/hud/itemPanel/Sprite").set_texture(load("res://textures/objects/items/"+item.get_name()+".tex"))
			Globals.set("item", item.get_name())

func drop(dropping_object_name,dropping_object_type,dir):
	print("dropping " + dropping_object_name)
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
	dropping = false
	get_node("../hero_floor/map_"+str(current_room)).add_object(dropping_object_name,dropping_object_type,pos_of_drop)
	
#to update stats of hero
func stats_update():
	attack = weapon.attack()
	defense = shield.defense() + helmet.defense()
	print(str(attack) + " " + str(defense))
#####################################################################################

func _on_touchBox_input_event( ev ):
	if (idle and (ev.type==InputEvent.SCREEN_TOUCH or ev.type==InputEvent.MOUSE_BUTTON)):
		var angle = Vector2(750-ev.x, 600-ev.y).angle()
		if (angle < 0.685 and angle > -0.685) :
			_move("up")
		if (angle <= -0.885 and angle >= -2.256):
			_move("right")
		if (angle <= 2.256 and angle >= 0.885):
			_move("left")
		if (angle < -2.456 or angle > 2.456) :
			_move("down")

func game_over():
	if (!game_over):
		get_node("Camera2D/CanvasLayer/Game_over").play("you_died")
		game_over = true


func _on_Game_over_finished():
	if (game_over):
		print("animation finished")
		get_node("..").game_over()

func _on_Blocked_move_anims_finished():
	idle = true

func _on_shield_control_input_event( ev ):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		print("Shield activated")
		var timeLeft = shield.active(get_node("../hero_floor/map_"+str(current_room)))
		if (timeLeft > 0):
			var t = Timer.new()
			t.set_wait_time(timeLeft)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			if shield.has("active2"):
				shield.active2(get_node("../hero_floor/map_"+str(current_room)))


func _on_helmet_control_input_event( ev ):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		print("Helmet activated")
		var timeLeft = helmet.active(get_node("../hero_floor/map_"+str(current_room)))
		if (timeLeft > 0):
			var t = Timer.new()
			t.set_wait_time(timeLeft)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			if helmet.has("active2"):
				helmet.active2(get_node("../hero_floor/map_"+str(current_room)))


func _on_weapon_control_input_event( ev ):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		print("Weapon activated")
		var timeLeft = weapon.active(get_node("../hero_floor/map_"+str(current_room)))
		if (timeLeft > 0):
			var t = Timer.new()
			t.set_wait_time(timeLeft)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			if weapon.has("active2"):
				weapon.active2(get_node("../hero_floor/map_"+str(current_room)))


func _on_item_control_input_event( ev ):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		print("Item activated")
		var timeLeft = item.active(get_node("../hero_floor/map_"+str(current_room)))
		if (timeLeft > 0):
			var t = Timer.new()
			t.set_wait_time(timeLeft)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			if item.has("active2"):
				item.active2(get_node("../hero_floor/map_"+str(current_room)))
