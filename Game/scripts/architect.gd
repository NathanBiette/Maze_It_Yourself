extends Node

var next_room
var doors_ids
#var library

func _ready():
	pass
	

func add_room(room_number):
	get_node("../.").add_room_architect(room_number)
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