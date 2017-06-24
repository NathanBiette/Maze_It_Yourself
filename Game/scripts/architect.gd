extends Node

var next_room
var doors_ids
var library

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	next_room = get_node("CanvasLayer/MenuButton/Panel/LineEdit").get_text()
	library = get_node("../../.").get_ENEMY_LIBRARY()
	for e in library:
		get_node("CanvasLayer/MenuButton/Panel/monster_button").add_item(e[1],e[0])

func update_doors(doors):
	for d in doors:
		get_node("CanvasLayer/MenuButton/Panel/OptionButton_1").add(d[1])
		get_node("CanvasLayer/MenuButton/Panel/OptionButton_2").add(d[1])

func update_spawn(spawns):
	for s in spawns:
		get_node("CanvasLayer/MenuButton/Panel/spawn_button").add(s[0])

func _on_Button_pressed():
	next_room = get_node("CanvasLayer/MenuButton/Panel/LineEdit").get_text()
	get_node("../.").add_room(next_room)
	update_doors(get_node("../.").get_doors())
	update_spawn(get_node("../.").get_spawns())
	#get_node("../..").websocket.send('{"event":"multicast","reason":"add_room","room":' + str(next_room) + '}')

func _on_connect_pressed():
	var door1 = get_node("CanvasLayer/MenuButton/Panel/OptionButton_1").get_selected_ID()
	var door_id1 = [int(door1/100), door1 - int(door1/100)*100]
	var door2 = get_node("CanvasLayer/MenuButton/Panel/OptionButton_2").get_selected_ID()
	var door_id2 = [int(door2/100), door2 - int(door2/100)*100]
	get_node("../.").connect(door_id1,door_id2)

func _on_link_pressed():
	var spawn =  get_node("CanvasLayer/MenuButton/Panel/spawn_button").get_selected_ID()
	var spawn_id = [int(spawn/100), spawn - int(spawn/100)*100]
	var monster_index = get_node("CanvasLayer/MenuButton/Panel/monster_button").get_selected()
	var monster = get_node("CanvasLayer/MenuButton/Panel/monster_button").get_item_text(monster_index)
	get_node("../.").link(spawn_id, monster)

func _on_Release_pressed():
	get_node("../.").update_release()

func remove_spawn_from_list(room):
	get_node("CanvasLayer/MenuButton/Panel/spawn_button").remove(room)