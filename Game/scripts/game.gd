extends Node

var websocket
var server_ip = 'warm-temple-69360.herokuapp.com'
var channel = 'global'

func _ready():
	websocket = preload('res://scripts/websocket.gd').new(self)
	websocket.start(server_ip,80)
	websocket.set_reciever(self,'_on_message_recieved')
	websocket.send('{"event":"connection","id":"' + OS.get_unique_ID() + '"}')
	
	var main_menu = preload('res://scenes/main_menu.tscn')
	var menu = main_menu.instance()
	get_node(".").add_child(menu)

func _on_message_recieved(msg):
	var dict = {}
	dict.parse_json(msg)
	if (dict.event == 'channel'):
		channel = dict.channel
	print(msg)
