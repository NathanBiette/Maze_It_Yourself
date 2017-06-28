extends Sprite

var websocket
onready var parent = get_node("..")

func _ready():
	websocket = parent.websocket


func _on_start_hero_pressed():
	var game_hero = preload("res://scenes/game_hero/demo.tscn")
	var hero = game_hero.instance()
	get_node("..").add_child(hero)
	queue_free()


func _on_connect_hero_pressed():
	if (get_node("CanvasLayer/enter_channel").get_text() != ''):
		websocket.send('{"event":"join","channel":"' + get_node("CanvasLayer/enter_channel").get_text() + '","role":"1"}')
		get_parent().set_role(2)



func _on_connect_architect_pressed():
	if (get_node("CanvasLayer/enter_channel").get_text() != ''):
		websocket.send('{"event":"join","channel":"' + get_node("CanvasLayer/enter_channel").get_text() + '","role":"2"}')
		get_parent().set_role(2)


func _on_leave_lobby_pressed():
	websocket.send('{"event":"leave"}')

func _on_message_recieved(msg):
	var dict = {}
	dict.parse_json(msg)
	var event = dict.event
	if (dict.event == "channel"):
		if(dict.event=="global"):
			get_node("CanvasLayer/status_text").set_text("Connected to server")
		else:
			get_node("CanvasLayer/status_text").set_text("Connected to channel " + dict.channel)
	if (dict.event == "ack"):
		get_node("CanvasLayer/status_text").set_text("Connected to server")
	if (dict.event == "soon"):
		get_node("CanvasLayer/status_text").set_text("Game is about to start!")
	if(dict.event == "start"):
		start_game_hero()

func start_game_hero():
	var game_hero = preload("res://scenes/game_hero/game_hero.tscn")
	var hero = game_hero.instance()
	get_node("..").add_child(hero)
	queue_free()

func start_game_architect():
	var game_archi = preload("res://scenes/game_architect/game_architect.tscn")
	var archi = game_archi.instance()
	get_node("..").add_child(archi)
	queue_free()

