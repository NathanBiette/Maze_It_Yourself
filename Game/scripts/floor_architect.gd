extends Node

#/!\ I cheat, I am not sending messages to the architect or the hero and just using the fact that the architect is a local variable of game hero and has access to spawns and doors

const OFFSET = 5000
const OFFSET_ARCHITECT = 2000
var rooms = Array()
#doors format : 
#	[[Vector2 global_pos, id [room number, door_type], id of connected door],[...],...]
var doors = Array()
var editable_doors = Array() #editable version for architect only
var doors_buttons = Array()
#spawns format : 
#	[[id [room number, spawn_index], Vector2 global_pos, hero_has_not_entered (bool), monster type (string)],[...],...]
var spawns = Array()
var looters = Array()
var number_of_rooms = 0
var explored_rooms = []
var this_is_my_first_time = true

#stocks buttons clicked for links between doors
var first_door_button = null
var second_door_button = null


func _ready():
	add_room(4)
	get_node("../..").websocket.send('{"event":"multicast","reason":"first_room"}')
	add_architect_view()

#==============================

func add_room(core_map_index):
	
	explored_rooms.append(0)
	if !this_is_my_first_time:
		get_node("../..").websocket.send('{"event":"multicast","reason":"add_room","room":"'+ str(core_map_index)+'"}')
	else:
		this_is_my_first_time = false
	
	var room = load("res://scenes/game_hero/rooms/hero_map.tscn")
	var room_node = room.instance()
	add_child(room_node)
	
	#creation of room
	
	var tile_map_scene = load("res://scenes/rooms/core_room_" + str(core_map_index) + ".tscn")
	var tile_map_node = tile_map_scene.instance()
	tile_map_node.set_global_pos(Vector2(OFFSET_ARCHITECT * number_of_rooms, 0))
		#setting up the room
	
	room_node.set_name("map_" + str(number_of_rooms))
	room_node.set_room_id(number_of_rooms)
	rooms.append(room_node)
	
	room_node.add_child(tile_map_node)
	#managing doors
	
	var temp_doors_locations = room_node.get_doors_locations()
	for i in range(4):
		if (temp_doors_locations[i] == Vector2(-1,-1)):
			pass
		else:
			doors.append([Vector2((temp_doors_locations[i][0] + (OFFSET_ARCHITECT/100 * number_of_rooms)) * 100 + 50,temp_doors_locations[i][1] * 100 + 50),[room_node.get_room_id(), i],[-1,-1]])
			editable_doors.append([Vector2((temp_doors_locations[i][0] + (OFFSET_ARCHITECT/100 * number_of_rooms)) * 100 + 50,temp_doors_locations[i][1] * 100 + 50),[room_node.get_room_id(), i],[-1,-1]])
	
	create_doors_button(number_of_rooms)
	create_looters(number_of_rooms)
	#managing spawn locations
	
	var temp_spawn_locations = room_node.get_spawn_locations()
	for i in range(temp_spawn_locations.size()):
		spawns.append([[number_of_rooms, i], temp_spawn_locations[i], true, ""])
	
	#updating for next_use
	number_of_rooms += 1
	room_node.set_pause_room(true)
#================================
func create_doors(active_room):
	
	#finds all doors in the the room and put at these locations a square for TP
	
	var doors_to_set = find_doors_in_room(active_room)
	for d in doors_to_set:
		var scene = load("res://scenes/game_hero/rooms/door.tscn")
		var node = scene.instance()
		node.set_door_id(d[1][0],d[1][1])
		node.set_global_pos(d[0])
		get_node("map_" + str(number_of_rooms)).add_child(node)
#===============================
func create_looters(active_room):
	var looters_to_set = get_node("map_" + str(active_room)).get_looters_locations()
	for location in looters_to_set:
		var scene = load("res://scenes/game_hero/rooms/looter.tscn")
		var node = scene.instance()
		node.set_location(location)
		node.set_global_pos(Vector2(location[0]*100+50 + OFFSET_ARCHITECT * number_of_rooms,location[1]*100+50))
		get_node("map_" + str(number_of_rooms)).add_child(node)

#================================
func find_doors_in_room(x):
	var l = []
	for d in doors:
		if (d[1][0] == x):
			l.append(d)
	return l
#================================
func get_my_door(door_id):
	return doors[find_door_index(door_id)][2]
#================================
func find_door_index(id):
	for i in range(doors.size()):
		if (doors[i][1] == id):
			return i
#================================
func get_doors():
	return doors
#================================
func get_spawns():
	return spawns
#================================
func get_spawn_index(id):
	for i in range(spawns.size()):
		if (spawns[i][0] == id):
			return i
#================================
func find_spawns_in_room(x):
	var l = []
	for s in spawns:
		if (s[0][0] == x):
			l.append(s)
	return l
#================================
func get_looters():
	return looters

#================================

func set_as_boss_room(id):
	var index = find_door_index(id)
	doors[index][2] = [-1,5]

#===================ARCHITECT ONLY==========================#
func add_architect():
	var scene = load("res://scenes/game_architect/architect.tscn")
	var node = scene.instance()
	add_child(node)

func add_architect_view():
	
	var scene = load("res://scenes/game_architect/architect_view.tscn")
	var node = scene.instance()
	add_child(node)

func connect(room):
	if second_door_button != null:
		var door_id1 = first_door_button.get_door_button_id()
		var door_id2 = second_door_button.get_door_button_id()
		if (door_id1[0] != room and door_id2[0] != room):
			return false
		if door_id1[0] == door_id2[0]:
			return false
		var i = find_door_index(door_id1)
		var j = find_door_index(door_id2)
		editable_doors[i][2] = door_id2
		editable_doors[j][2] = door_id1
		return true
	return false

func link(spawn_id, monster):
	var i = get_spawn_index(spawn_id)
	if spawns[i][2] == true:
		spawns[i][3] = monster

func update_release():
	var edition_ok = true
	for i in range (doors.size()):
		if doors[i][2] == [-1,-1]:
			pass
		elif doors[i][2] == editable_doors[i][2]:
			pass
		else:
			edition_ok = false
	if edition_ok == true:
		doors = str2var(var2str(editable_doors))
		var translated_doors = str2var(var2str(doors))
		for k in range(doors.size()):
			translated_doors[k][0][0] -= OFFSET_ARCHITECT * translated_doors[k][1][0]
			translated_doors[k][0][0] += OFFSET * translated_doors[k][1][0]
			print(translated_doors[k])
		print(translated_doors)
		get_node("../..").websocket.send('{"event":"multicast","reason":"update","spawns":"' + var2str(var2bytes(spawns)) + '","doors":"' + var2str(var2bytes(translated_doors)) + '"}')
	else:
		editable_doors = str2var(var2str(doors))
		get_node("architect/CanvasLayer/WindowDialog").popup()

func close_spawns(room):
	for s in spawns:
		if s[0][0] == room:
			s[2] = false
	explored_rooms[room]=1
	get_node("architect").remove_spawn_from_list(room)


func _on_pressed_button(button):
	if button != first_door_button:
		if second_door_button != null:
			second_door_button.set_opacity(1)
		second_door_button = first_door_button
		first_door_button = button
		first_door_button.set_opacity(0.5)

func create_doors_button(active_room):
	#finds all doors in the the room and put at these locations a square for TP
	var doors_to_set = find_doors_in_room(active_room)
	for d in doors_to_set:
		var scene = load("res://scenes/game_hero/rooms/door_button.tscn")
		var node = scene.instance()
		print(get_node("map_" + str(number_of_rooms)).get_name())
		get_node("map_" + str(number_of_rooms)).add_child(node)
		node.set_door_button_id(d[1][0],d[1][1])
		node.set_global_pos(Vector2(d[0][0]-100,d[0][1]-100))
		node.connect("pressed_button", self, "_on_pressed_button")

func translate(array):
	for k in range(array.size()):
		array[k][0][0] -= OFFSET_ARCHITECT * array[k][1][0]
		array[k][0][0] += OFFSET * array[k][1][0]
	return array