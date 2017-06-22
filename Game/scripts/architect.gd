extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var next_room
var doors_ids

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	next_room = get_node("CanvasLayer/MenuButton/Panel/LineEdit").get_text()
	set_process(true)

func update_doors(doors):
	for d in doors:
		get_node("CanvasLayer/MenuButton/Panel/OptionButton_1").add(d[1])
		get_node("CanvasLayer/MenuButton/Panel/OptionButton_2").add(d[1])

func _process(delta):
	pass

func _on_Button_pressed():
	next_room = get_node("CanvasLayer/MenuButton/Panel/LineEdit").get_text()
	get_node("../.").add_room(next_room)
	update_doors(get_node("../.").get_doors())

func _on_connect_pressed():
	var door1 = get_node("CanvasLayer/MenuButton/Panel/OptionButton_1").get_selected_ID()
	var door_id1 = [int(door1/10), door1 - int(door1/10)*10]
	var door2 = get_node("CanvasLayer/MenuButton/Panel/OptionButton_2").get_selected_ID()
	var door_id2 = [int(door2/10), door2 - int(door2/10)*10]
	get_node("../.").connect(door_id1,door_id2)

func _on_link_pressed():
	var spawn =  get_node("CanvasLayer/MenuButton/Panel/spawn_button").get_selected_ID()
	var spawn_id = [int(spawn/10),  - int(spawn/10)*10]
	var monster = get_node("CanvasLayer/MenuButton/Panel/monster_button").get_selected_ID()
	get_node("../.").link(spawn, monster)

func _on_Release_pressed():
	get_node("../.").update_release()
