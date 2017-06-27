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

var hasItem = true

#cooldowns
var helmet_on_cooldown = false
var weapon_on_cooldown = false
var shield_on_cooldown = false
var item_on_cooldown = false

var helmet_timer
var weapon_timer
var shield_timer
var item_timer

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

	#compute attack and defense stats
	attack = weapon.attack()
	defense = shield.defense() + helmet.defense()

	get_node("Camera2D/hud/healthBar").set_value((float(current_HP)/float(max_HP))*100)
	get_node("Camera2D/hud/coinSprite/coinLabel").set_text(str(Globals.get("gold")))
	get_node("Camera2D/hud/weaponPanel/Sprite").set_texture(load("res://textures/objects/weapons/"+weapon.get_name()+".tex"))
	get_node("Camera2D/hud/helmetPanel/Sprite").set_texture(load("res://textures/objects/helmets/"+helmet.get_name()+".tex"))
	get_node("Camera2D/hud/shieldPanel/Sprite").set_texture(load("res://textures/objects/shields/"+shield.get_name()+".tex"))
	get_node("Camera2D/hud/itemPanel/Sprite").set_texture(load("res://textures/objects/items/"+item.get_name()+".tex"))
	
	set_process(true)

func _process(delta):
	
	get_node("Camera2D/hud/coinSprite/coinLabel").set_text(str(Globals.get("gold")))
	
	shield_on_cooldown = shield.is_on_cooldown()
	helmet_on_cooldown = helmet.is_on_cooldown()
	weapon_on_cooldown = weapon.is_on_cooldown()
	if item != null:
		item_on_cooldown = item.is_on_cooldown()
	else:
		item_on_cooldown = false
	
	if shield.cooldown() > 0: 
		if shield_on_cooldown:
			get_node("Camera2D/hud/shieldPanel/shieldProgress").set_value(100.0-float(shield_timer.get_time_left())/float(shield.cooldown())*100.0)
		else:
			get_node("Camera2D/hud/shieldPanel/shieldProgress").set_value(100)
	else:
		get_node("Camera2D/hud/shieldPanel/shieldProgress").set_value(0)
		
	if helmet.cooldown() > 0:
		if helmet_on_cooldown:
			get_node("Camera2D/hud/helmetPanel/helmetProgress").set_value(100.0-float(helmet_timer.get_time_left())/float(helmet.cooldown())*100.0)
		else:
			get_node("Camera2D/hud/helmetPanel/helmetProgress").set_value(100)
	else:
		get_node("Camera2D/hud/helmetPanel/helmetProgress").set_value(0)
		
	if weapon.cooldown() > 0:
		if weapon_on_cooldown:
			get_node("Camera2D/hud/weaponPanel/weaponProgress").set_value(100.0-float(weapon_timer.get_time_left())/float(weapon.cooldown())*100.0)
		else:
			get_node("Camera2D/hud/weaponPanel/weaponProgress").set_value(100)
	else:
		get_node("Camera2D/hud/weaponPanel/weaponProgress").set_value(0)
	if item != null:
		if item.cooldown() > 0:
			if item_on_cooldown:
				get_node("Camera2D/hud/itemPanel/itemProgress").set_value(100.0-float(item_timer.get_time_left())/float(item.cooldown())*100.0)
			else:
				get_node("Camera2D/hud/itemPanel/itemProgress").set_value(100)
		else:
			get_node("Camera2D/hud/itemPanel/itemProgress").set_value(0)

#move script of theseus
func _move(dir):
	#part called to move theseus
	if idle:
		get_node("SamplePlayer2D").play("step")
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
				get_node("SamplePlayer2D").play("sword")
				idle = false
				revert_motion()
				collider.interact(dir, get_node("."))
			#collision with door
			elif (collider.is_in_group("door")) :
				revert_motion()
				collider.shazaam()
				get_node("AnimatedSprite/Blocked_move_anims").queue("blocked_move_" + dir)
			elif(collider.is_in_group("looter")) :
				revert_motion()
				collider.give_loot(current_room)
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
		var effective_damage = max(1, damage - defense)
		current_HP -= effective_damage
		get_node("SamplePlayer2D").play("ouch")
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
		if hasItem:
			drop(dropping_object_name,dropping_object_type,dir)
		else:
			dropping = false
			hasItem = true
	if (looting):
		loot(looting_object_name, looting_object_type)
		looting = false
		dropping = true
	#update stats of theseus
	stats_update()

func loot(looting_object_name,looting_object_type):
	get_node("SamplePlayer2D").play("loot")
	if (looting_object_type == "weapons"):
			dropping_object_name = weapon.get_name()
			dropping_object_type = "weapons"
			#free previous weapon node before using weapon var again to store new weapon
			#weapon.queue_free()
			#load node of colliding item for it not to be destroyed on freeing from map
			weapon = load("res://scenes/game_hero/objects/"+looting_object_type+"/"+looting_object_name+".tscn").instance()
			get_node("Camera2D/hud/weaponPanel/Sprite").set_texture(load("res://textures/objects/weapons/"+weapon.get_name()+".tex"))
			if (weapon.cooldown() > 0):
				weapon_cooldown(weapon)
			#save weapon reference 
			Globals.set("weapon", weapon.get_name())
	if (looting_object_type == "shields"):
			dropping_object_name = shield.get_name()
			dropping_object_type = "shields"
			#shield.queue_free()
			shield = load("res://scenes/game_hero/objects/"+looting_object_type+"/"+looting_object_name+".tscn").instance()
			get_node("Camera2D/hud/shieldPanel/Sprite").set_texture(load("res://textures/objects/shields/"+shield.get_name()+".tex"))
			if (shield.cooldown() > 0):
				shield_cooldown(shield)
			Globals.set("shield", helmet.get_name())
	if (looting_object_type == "helmets"):
			dropping_object_name = helmet.get_name()
			dropping_object_type = "helmets"
			#helmet.queue_free()
			helmet = load("res://scenes/game_hero/objects/"+looting_object_type+"/"+looting_object_name+".tscn").instance()
			get_node("Camera2D/hud/helmetPanel/Sprite").set_texture(load("res://textures/objects/helmets/"+helmet.get_name()+".tex"))
			if (helmet.cooldown() > 0):
				helmet_cooldown(helmet)
			Globals.set("helmet", helmet.get_name())
	if (looting_object_type == "items"):
			if item != null:
				dropping_object_name = item.get_name()
				dropping_object_type = "items"
			#items.queue_free()
			item = load("res://scenes/game_hero/objects/"+looting_object_type+"/"+looting_object_name+".tscn").instance()
			get_node("Camera2D/hud/itemPanel/Sprite").set_texture(load("res://textures/objects/items/"+item.get_name()+".tex"))
			if (item.cooldown() > 0):
				item_cooldown(item)
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
	if item != null:
		attack = weapon.attack() + item.attack()
		defense = shield.defense() + helmet.defense() + item.defense()
	else:
		attack = weapon.attack()
		defense = shield.defense() + helmet.defense()
	print(str(attack) + " " + str(defense))

#to heal the hero
func heal(value):
	current_HP = min(max_HP, current_HP + value)
	get_node("Camera2D/hud/healthBar").set_value((float(current_HP)/float(max_HP))*100.0)

#####################################################################################

func game_over():
	if (!game_over):
		get_node("Camera2D/CanvasLayer/Game_over").play("you_died")
		get_node("SamplePlayer2D").play("gameover")
		game_over = true


func _on_Game_over_finished():
	if (game_over):
		get_node("..").game_over()

func _on_Blocked_move_anims_finished():
	idle = true

func _on_shield_control_input_event( ev ):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		if shield_on_cooldown:
			return
		print("Shield activated")
		if (shield == null):
			return
		var timeLeft = shield.active(get_node("../hero_floor/map_"+str(current_room)))
		var cooldown = shield.cooldown()
		var shieldUsed = shield
		if (cooldown > 0):
			shield_cooldown(shield)
		if (timeLeft > 0):
			var t = Timer.new()
			t.set_wait_time(timeLeft)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			shieldUsed.active2(get_node("../hero_floor/map_"+str(current_room)))


func _on_helmet_control_input_event( ev ):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		print("Helmet activated")
		if (helmet == null):
			return
		var timeLeft = helmet.active(get_node("../hero_floor/map_"+str(current_room)))
		var cooldown = helmet.cooldown()
		var helmetUsed = helmet
		if (cooldown > 0):
			helmet_cooldown(helmet)
		if (timeLeft > 0):
			var t = Timer.new()
			t.set_wait_time(timeLeft)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			helmetUsed.active2(get_node("../hero_floor/map_"+str(current_room)))


func _on_weapon_control_input_event( ev ):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		print("Weapon activated")
		if (weapon == null):
			return
		var timeLeft = weapon.active(get_node("../hero_floor/map_"+str(current_room)))
		var cooldown = weapon.cooldown()
		var weaponUsed = weapon
		if (cooldown > 0):
			weapon_cooldown(weapon)
		if (timeLeft > 0):
			var t = Timer.new()
			t.set_wait_time(timeLeft)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			weaponUsed.active2(get_node("../hero_floor/map_"+str(current_room)))


func _on_item_control_input_event( ev ):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		print("Item activated")
		if (item == null):
			return
		var timeLeft = item.active(get_node("../hero_floor/map_"+str(current_room)))
		var cooldown = item.cooldown()
		var itemUsed = item
		if (cooldown > 0):
			item_cooldown(item)
		if item.is_one_use():
			item = null
			hasItem = false
			get_node("Camera2D/hud/itemPanel/Sprite").set_texture(null)
			Globals.set("item", null)
		if (timeLeft > 0):
			var t = Timer.new()
			t.set_wait_time(timeLeft)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			itemUsed.active2(get_node("../hero_floor/map_"+str(current_room)))

func shield_cooldown(sh):
	shield_timer = Timer.new()
	shield_timer.set_wait_time(sh.cooldown())
	shield_timer.set_one_shot(true)
	self.add_child(shield_timer)
	shield_timer.start()
	sh.set_timer(shield_timer)
	sh.set_on_cooldown(true)
	yield(shield_timer, "timeout")
	sh.set_on_cooldown(false)

func helmet_cooldown(he):
	helmet_timer = Timer.new()
	helmet_timer.set_wait_time(he.cooldown())
	helmet_timer.set_one_shot(true)
	self.add_child(helmet_timer)
	helmet_timer.start()
	he.set_timer(helmet_timer)
	he.set_on_cooldown(true)
	yield(helmet_timer, "timeout")
	he.set_on_cooldown(false)

func weapon_cooldown(we):
	weapon_timer = Timer.new()
	weapon_timer.set_wait_time(we.cooldown())
	weapon_timer.set_one_shot(true)
	self.add_child(weapon_timer)
	weapon_timer.start()
	we.set_timer(weapon_timer)
	we.set_on_cooldown(true)
	yield(weapon_timer, "timeout")
	we.set_on_cooldown(false)

func item_cooldown(it):
	item_timer = Timer.new()
	item_timer.set_wait_time(it.cooldown())
	item_timer.set_one_shot(true)
	self.add_child(item_timer)
	item_timer.start()
	it.set_timer(item_timer)
	it.set_on_cooldown(true)
	yield(item_timer, "timeout")
	it.set_on_cooldown(false)

func _on_right_input_event( ev ):
	if(ev.type == InputEvent.MOUSE_BUTTON):
		_move("right")

func _on_left_input_event( ev ):
	if(ev.type == InputEvent.MOUSE_BUTTON):
		_move("left")

func _on_up_input_event( ev ):
	if(ev.type == InputEvent.MOUSE_BUTTON):
		_move("up")

func _on_down_input_event( ev ):
	if(ev.type == InputEvent.MOUSE_BUTTON):
		_move("down")


func _on_end_game_finished():
	get_node("..").game_over()
