extends Node

var websocket
var server_ip = 'warm-temple-69360.herokuapp.com'
var port = 80
#var server_ip = '137.194.23.37'
#var port = 3000
var channel = 'global'
var timer

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
	print(dict)
	if (dict.event == 'channel'):
		channel = dict.channel
	if (dict.event == 'ping'):
		timer.stop()
		timer.set_wait_time(35)
		timer.start()
		websocket.send('{"event":"pong"}')

func _on_timer_timeout():
	timer.stop()
	print("Timed out")
	# Handle the disconnection
