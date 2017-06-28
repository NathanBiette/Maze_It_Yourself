extends Sprite

var websocket
onready var parent = get_node("..")

func _ready():
	websocket = parent.websocket
	get_node("CanvasLayer/start_game").set_hidden(true)
	get_node("CanvasLayer/leave_lobby").set_hidden(true)


func _on_start_hero_pressed():
	var game_hero = load("res://scenes/game_hero/demo.tscn")
	var hero = game_hero.instance()
	get_node("..").add_child(hero)
	queue_free()


func _on_connect_hero_pressed():
	if (get_node("CanvasLayer/enter_channel").get_text() != ''):
		websocket.send('{"event":"join","channel":"' + get_node("CanvasLayer/enter_channel").get_text() + '","role":"1"}')
		get_parent().set_role(1)
		get_node("CanvasLayer/start_hero").set_hidden(true)
		get_node("CanvasLayer/connect_architect").set_hidden(true)
		get_node("CanvasLayer/connect_hero").set_hidden(true)
		get_node("CanvasLayer/enter_channel").set_hidden(true)
		get_node("CanvasLayer/leave_lobby").set_hidden(false)



func _on_connect_architect_pressed():
	if (get_node("CanvasLayer/enter_channel").get_text() != ''):
		websocket.send('{"event":"join","channel":"' + get_node("CanvasLayer/enter_channel").get_text() + '","role":"2"}')
		get_parent().set_role(2)
		get_node("CanvasLayer/start_hero").set_hidden(true)
		get_node("CanvasLayer/connect_architect").set_hidden(true)
		get_node("CanvasLayer/connect_hero").set_hidden(true)
		get_node("CanvasLayer/enter_channel").set_hidden(true)
		get_node("CanvasLayer/leave_lobby").set_hidden(false)


func _on_leave_lobby_pressed():
	websocket.send('{"event":"leave"}')
	get_node("CanvasLayer/start_hero").set_hidden(false)
	get_node("CanvasLayer/connect_architect").set_hidden(false)
	get_node("CanvasLayer/connect_hero").set_hidden(false)
	get_node("CanvasLayer/enter_channel").set_hidden(false)
	get_node("CanvasLayer/leave_lobby").set_hidden(true)

func start_game_hero():
	var game_hero = load("res://scenes/game_hero/game_hero.tscn")
	var hero = game_hero.instance()
	get_node("..").add_child(hero)
	queue_free()

func start_game_architect():
	var game_archi = load("res://scenes/game_architect/game_architect.tscn")
	var archi = game_archi.instance()
	get_node("..").add_child(archi)
	queue_free()



func _on_start_game_pressed():
	if (get_parent().is_ingame()):
		if (get_parent().role==1):
			start_game_hero()
		elif(get_parent().role==2):
			start_game_architect()
