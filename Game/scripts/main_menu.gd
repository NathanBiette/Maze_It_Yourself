extends Sprite

var websocket
var server_ip = '137.194.23.37'
var channel = 'global'

func _ready():
	websocket = preload('websocket.gd').new(self)
	websocket.start('137.194.23.37',3000)
	websocket.set_reciever(self,'_on_message_recieved')
	websocket.send('{"event":"connection","id":"' + OS.get_unique_ID() + '"}')

func _on_message_recieved(msg):
	var dict = {}
	dict.parse_json(msg)
	if (dict.event == 'channel'):
		channel = dict.channel
	print(msg)


func _on_start_architect_pressed():
	pass # replace with function body


func _on_start_hero_pressed():
	get_tree().change_scene("res://scenes/game_hero/game_hero.tscn")


func _on_disconnect_pressed():
	pass # replace with function body


func _on_connect_hero_pressed():
	if (get_node("CanvasLayer/enter_channel").get_text() != ''):
		websocket.send('{"event":"join","channel":' + get_node("CanvasLayer/enter_channel").get_text() + ',"role":"1"}')


func _on_connect_architect_pressed():
	if (get_node("CanvasLayer/enter_channel").get_text() != ''):
		websocket.send('{"event":"join","channel":' + get_node("CanvasLayer/enter_channel").get_text() + ',"role":"2"}')


func _on_leave_lobby_pressed():
	websocket.send('{"event":"leave"}')
