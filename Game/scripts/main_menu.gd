extends Sprite

var websocket
onready var parent = get_node("..")

func _ready():
	websocket = parent.websocket

func _on_message_recieved(msg):
	var dict = {}
	dict.parse_json(msg)
	if (dict.event == 'channel'):
		channel = dict.channel
	print(msg)


func _on_start_architect_pressed():
	var game_architect = preload("res://scenes/game_architect/game_architect.tscn")
	var arch = game_architect.instance()
	get_node("..").add_child(arch)
	queue_free()


func _on_start_hero_pressed():
	var game_hero = preload("res://scenes/game_hero/game_hero.tscn")
	var hero = game_hero.instance()
	get_node("..").add_child(hero)
	queue_free()


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
