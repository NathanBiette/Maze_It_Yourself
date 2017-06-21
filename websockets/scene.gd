
extends Node

#var peer = StreamPeerTCP.new()
var websocket

var run_time = 0
var channel = 1;

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
	print("This is a message: " + msg)


func _on_Button_pressed():
	channel = 1-channel
	websocket.send('{ "event": "channel", "channel":' + str(channel) + ' }')
	print('cl')



