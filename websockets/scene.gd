
extends Node

#var peer = StreamPeerTCP.new()
var websocket

var run_time = 0
var channel = 1;
var role = 1;

func _process(delta):
	#print(peer.is_connected())
	#print(peer.get_status())
	run_time += delta
	get_node("time").set_text(str(run_time).pad_decimals(2))

func _ready():
	#peer.connect('127.0.0.1',3001)
	
	set_process(true)
	
	print( get_tree() )
	
	websocket = preload('websocket.gd').new(self)
	websocket.start('137.194.23.37',3000)
	websocket.set_reciever(self,'_on_message_recieved')

func _on_message_recieved(msg):
	var dict = {}
	dict.parse_json(msg)
	if (dict.event == 'channel'):
		channel = dict.channel
		return
	if (dict.event == 'update'):
		print(dict.msg)


func _on_Button_pressed():
	websocket.send('{ "event": "join", "channel":' + str(1-channel) + ',"role":' + role + '}')
	print('Sent change channel')





func _on_updateButton_pressed():
	websocket.send('{ "event": "update", "msg":"Hello there" }')
	print('Sent update')


func _on_changeRoleButton_pressed():
	if (role == 1):
		role = 2
	else:
		role = 1;
