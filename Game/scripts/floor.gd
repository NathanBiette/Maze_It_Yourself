extends Node

#/!\ I cheat, I am not sending messages to the architect or the hero and just using the fact that the architect is a local variable of game hero and has access to spawns and doors

const OFFSET = 5000
var rooms = Array()
#doors format : 
#	[[Vector2 global_pos, id [room number, door_type], id of connected door],[...],...]
var doors = Array()
var editable_doors = Array() #editable version for architect only
#spawns format : 
#	[[id [room number, spawn_index], Vector2 global_pos, hero_has_not_entered (bool), monster type (string)],[...],...]
var spawns = Array()
var looters = Array()
var number_of_rooms = 0


func _ready():
	
	add_room(4)
	#hero_exclusive
	if get_node("../.").get_name() == "game_hero":
		add_architect()
		get_node("architect").update_doors(doors)
		get_node("architect").update_spawn(spawns)
		get_node("map_"+str(get_node("../theseus").get_current_room())).set_pause_room(false)
	elif get_node("../.").get_name() == "game_architect":
		add_architect_view()
		add_architect()

#==============================

func add_room(core_map_index):
	
	var room = load("res://scenes/game_hero/rooms/hero_map.tscn")
	var room_node = room.instance()
	add_child(room_node)
	
	#creation of room
	
	var tile_map_scene = load("res://scenes/rooms/core_room_" + str(core_map_index) + ".tscn")
	var tile_map_node = tile_map_scene.instance()
	room_node.add_child(tile_map_node)
	
	#setting up the room
	
	room_node.set_name("map_" + str(number_of_rooms))
	room_node.set_room_id(number_of_rooms)
	rooms.append(room_node)
	room_node.get_node("TileMap").set_global_pos(Vector2(OFFSET * number_of_rooms, 0))
	
	#managing doors
	
	var temp_doors_locations = room_node.get_doors_locations()
	for i in range(4):
		if (temp_doors_locations[i] == Vector2(-1,-1)):
			pass
		else:
			var new_door = [Vector2((temp_doors_locations[i][0] + (50 * number_of_rooms)) * 100 + 50,temp_doors_locations[i][1] * 100 + 50),[room_node.get_room_id(), i],[-1,-1]]
			doors.append([Vector2((temp_doors_locations[i][0] + (50 * number_of_rooms)) * 100 + 50,temp_doors_locations[i][1] * 100 + 50),[room_node.get_room_id(), i],[-1,-1]])
			
			#for later when we have a real architect
			
			#if get_node("../.").get_name() == "game_architect":
			editable_doors.append([Vector2((temp_doors_locations[i][0] + (50 * number_of_rooms)) * 100 + 50,temp_doors_locations[i][1] * 100 + 50),[room_node.get_room_id(), i],[-1,-1]])
		
	create_doors(number_of_rooms)
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
		get_node("map_" + str(number_of_rooms)).add_child(node)
		node.set_door_id(d[1][0],d[1][1])
		node.set_global_pos(d[0])
#===============================
func create_looters(active_room):
	var looters_to_set = get_node("map_" + str(active_room)).get_looters_locations()
	for location in looters_to_set:
		var scene = load("res://scenes/game_hero/rooms/looter.tscn")
		var node = scene.instance()
		get_node("map_" + str(number_of_rooms)).add_child(node)
		node.set_location(location)
		node.set_global_pos(Vector2(location[0]*100+50 + OFFSET * number_of_rooms,location[1]*100+50))
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
#=============HERO ONLY==================#

func change_room(door_id):
	var current_door_index = find_door_index(door_id)
	var next_door_id = doors[current_door_index][2]
	var next_door_index = find_door_index(next_door_id) 
	
	#creating monsters from spawns array
	
	var spawns_in_room = find_spawns_in_room(next_door_id[0])
	for s in spawns_in_room:
		if s[3] == "":
			pass
		elif s[2]:
			var enemy_scene = load("res://scenes/game_hero/enemies/" + s[3] + ".tscn")
			var enemy_node = enemy_scene.instance()
			get_node("map_" + str(next_door_id[0]) + "/TileMap").add_child(enemy_node)
			enemy_node.set_pos(Vector2(s[1][0]*100 +50,s[1][1]*100 +50))
			s[2] = false
	#get_node("../..").websocket.send('{"event":"multicast","reason":"close_spawns","room":' + str(next_door_id[0]) + '}')
	
	if (next_door_id == [-1,-1]):
		pass
	#NORTH CASE
	elif (next_door_id[1] == 0):
		get_node("../theseus").set_global_pos(Vector2(doors[next_door_index][0][0], doors[next_door_index][0][1] + 100))
		get_node("../theseus").set_current_room(next_door_id[0])
		get_node("map_"+str(next_door_id[0])).close_doors()
	#WEST CASE
	elif (next_door_id[1] == 1):
		get_node("../theseus").set_global_pos(Vector2(doors[next_door_index][0][0] + 100, doors[next_door_index][0][1]))
		get_node("../theseus").set_current_room(next_door_id[0])
		get_node("map_"+str(next_door_id[0])).close_doors()
	#SOUTH CASE
	elif (next_door_id[1] == 2):
		get_node("../theseus").set_global_pos(Vector2(doors[next_door_index][0][0], doors[next_door_index][0][1] - 100))
		get_node("../theseus").set_current_room(next_door_id[0])
		get_node("map_"+str(next_door_id[0])).close_doors()
	#EAST CASE
	elif (next_door_id[1] == 3):
		get_node("../theseus").set_global_pos(Vector2(doors[next_door_index][0][0] - 100, doors[next_door_index][0][1]))
		get_node("../theseus").set_current_room(next_door_id[0])
		get_node("map_"+str(next_door_id[0])).close_doors()
	get_node("map_"+str(get_node("../theseus").get_current_room())).set_pause_room(false)
	

func update(new_doors, new_spawns):
	doors = new_doors
	spawns = new_spawns

#=============HERO ONLY END===============#

#===================ARCHITECT ONLY==========================#
func add_architect():
	var scene = load("res://scenes/game_architect/architect.tscn")
	var node = scene.instance()
	add_child(node)

func add_architect_view():
	var scene = load("res://scenes/game_architect/architect_view.tscn")
	var node = scene.instance()
	add_child(node)

func connect(door_id1,door_id2):
	var i = find_door_index(door_id1)
	var j = find_door_index(door_id2)
	editable_doors[i][2] = door_id2
	editable_doors[j][2] = door_id1

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
		print(str(doors))
		get_node("../..").websocket.send('{"event":"multicast","reason":"update","spawns":"' + str(spawns) + '","doors":"' + str(doors) + '"}')
	else:
		editable_doors = str2var(var2str(doors))
		get_node("architect/CanvasLayer/WindowDialog").popup()

func close_spawns(room):
	for s in spawns:
		if s[0][0] == room:
			s[2] = false
	get_node("architect").remove_spawn_from_list(room)