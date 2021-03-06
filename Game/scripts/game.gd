extends Node

var websocket
var server_ip = 'warm-temple-69360.herokuapp.com'
var port = 80
#var server_ip = '137.194.23.194'
#var port = 3000
var channel = 'global'
var timer
var reconnectionTries = 0
var reconnectionTimer
var connected = false
var ingame = false # Used to check if the player is in-game or not
var role
const ENEMY_LIBRARY = [[1,'skeleton'],[2,'giant'],[3,'gorgon']]
const ITEMS_LIBRARY = [[1,"helmets/basic_helmet"],[2,"items/ambrosia_potion"],[3,"items/necklace"],[4,"shields/basic_shield"],[5,"shields/cronos_shield"],[6,"weapons/steel_sword"],[7,"helmets/barbute_helmet"],[8,"items/health_potion"],[9,"items/health_potion"],[10,"items/health_potion"],[11,"items/health_potion"],[12,"items/health_potion"]]

func _ready():
	websocket = preload('res://scripts/websocket.gd').new(self)
	websocket.start(server_ip,port)
	websocket.set_reciever(self,'_on_message_recieved')
	websocket.send('{"event":"connection","id":"' + OS.get_unique_ID() + '"}')
	
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout")
	timer.set_wait_time(35)
	add_child(timer)
	timer.start()
	
	var main_menu = preload('res://scenes/main_menu.tscn')
	var menu = main_menu.instance()
	get_node(".").add_child(menu)

func _on_message_recieved(msg):
	var dict = {}
	dict.parse_json(msg)
	#print(msg)
	#print(dict)
	if (dict.event == "channel"):
		channel = dict.channel
		if(channel=='global'):
			get_node("background/CanvasLayer/status_text").set_text("Connected to server")
		else:
			get_node("background/CanvasLayer/status_text").set_text("Connected to channel " + dict.channel)
	if (dict.event == 'ping'):
		timer.stop()
		timer.set_wait_time(35)
		timer.start()
		websocket.send('{"event":"pong"}')
	if (dict.event == 'ack'):
		connected = true
		get_node("background/CanvasLayer/status_text").set_text("Connected to server")
		print('Connected')
	if (dict.event == "soon"):
		get_node("background/CanvasLayer/status_text").set_text("Game is about to start!")
	if(dict.event == "start"):
		get_node("background/CanvasLayer/status_text").set_text("Game has started! Press start to join.")
		if role == 1:
			get_node("background/CanvasLayer/start_game").set_hidden(false)
		elif role == 2:
			get_node("background/CanvasLayer/waiting_hero").set_hidden(false)
		get_node("background/CanvasLayer/leave_lobby").set_hidden(true)
		ingame = true
	if (dict.reason == 'first_room'):
		get_node("game_hero/theseus").set_idle(true)
		get_node("game_hero/theseus").time_start = OS.get_unix_time()
		get_node("game_hero/theseus/Camera2D/hud/stopwatch").set_hidden(false)
		get_node("game_hero/theseus/Camera2D/hud/waiting_architect").set_hidden(true)
	if (dict.reason == 'hero_ready'):
		get_node("background/CanvasLayer/waiting_hero").set_hidden(true)
		get_node("background/CanvasLayer/start_game").set_hidden(false)
	if (dict.reason == 'add_room'):
		get_child(1).get_node("hero_floor").add_room(dict.room)
	if (dict.reason == 'first_room'):
		get_child(1).get_node("hero_floor").first_room()
	if dict.reason == 'close_spawns':
		get_child(1).get_node("architect_floor").close_spawns(dict.room)
		get_child(1).set_gold_income(true)
	if dict.reason == 'update':
		get_child(1).get_node("hero_floor").update(bytes2var(str2var(dict.doors)), bytes2var(str2var(dict.spawns)))
	if dict.reason == 'room_finished':
		get_child(1).set_gold_income(false)
		#to do: switch in slow resource mode
	if dict.reason == 'game_over':
		get_node("game_architect/architect_floor/Camera2D/CanvasLayer/Revenge").play("revenge")
	if dict.reason == 'game_won':
		get_node("game_architect/architect_floor/Camera2D/CanvasLayer/Defeat").play("failed")



func _on_timer_timeout():
	timer.stop()
	print("Timed out")
	connected = false

func set_role(i):
	role = i

func get_ENEMY_LIBRARY():
	return ENEMY_LIBRARY
func get_ITEMS_LIBRARY():
	return ITEMS_LIBRARY
func is_ingame():
	return ingame
#	
#	reconnectionTimer = Timer.new()
#	reconnectionTimer.connect("timeout",self,"_on_reconnection_timer_timeout")
#	reconnectionTimer.set_wait_time(3)
#	add_child(reconnectionTimer)
#	reconnectionTimer.start()
#	# Handle the disconnection
#
#func _on_reconnection_timer_timeout():
#	if (connected == true):
#		reconnectionTimer.stop()
#		remove_child(reconnectionTimer)
#		print('Reconnected')
#		return
#	websocket = preload('res://scripts/websocket.gd').new(self)
#	websocket.start(server_ip,port)
#	websocket.set_reciever(self,'_on_message_recieved')
#	websocket.send('{"event":"connection","id":"' + OS.get_unique_ID() + '"}')
#	get_child(1).websocket = websocket
#	reconnectionTimer.stop()
#	reconnectionTries += 1
#	reconnectionTimer.set_wait_time(3)
#	reconnectionTimer.start()

func game_over():
	var main_menu = preload('res://scenes/main_menu.tscn')
	var menu = main_menu.instance()
	self.add_child(menu)