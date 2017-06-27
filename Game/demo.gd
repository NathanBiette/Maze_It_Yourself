extends Node

var theseus_hero
var theseus_instance
var level_scene
var level_instance

func _ready():
	
	#initialise globals player variables
	Globals.set("hp",10)
	Globals.set("helmet","basic_helmet")
	Globals.set("weapon","basic_weapon")
	Globals.set("shield","basic_shield")
	Globals.set("item","basic_item")
	Globals.set("gold",0)
	


	#load hero 
	theseus_hero = load("res://scenes/game_hero/theseus.tscn")
	theseus_instance = theseus_hero.instance()
	add_child(theseus_instance)
	
	#load level
	level_scene = load("res://scenes/game_hero/hero_floor.tscn")
	level_instance = level_scene.instance()
	add_child(level_instance)
	for k in range(0,4):
		level_instance.add_room(k)
	var  doors=level_instance.get_doors()
	print(doors)
	var size = doors.size()
	randomize()
	while (doors.size()>0):
		size=doors.size()
		var end_early=true
		for k in range(size-1):
			if(doors[k][1][0] != doors[k+1][1][0]):
				end_early=false
		if(!end_early):
			var k = 0
			var i = 0
			while(doors[i][1][0]==doors[k][1][0]):
				i=randi()%size
				k=randi()%size
			level_instance.connect(doors[i][1],doors[k][1])
			if(k>i):
				doors.remove(k)
				doors.remove(i)
			else:
				doors.remove(i)
				doors.remove(k)
		elif(end_early):
			doors = []
	var spawns = level_instance.get_spawns()
	var k = 0
	for k in range(spawns.size()):
		var i = randi()%5+1
		if (i==4):
			level_instance.link(spawns[k][0],"giant")
		else:
			level_instance.link(spawns[k][0],"gorgon")
	level_instance.update_release()

func game_over():
	get_node("..").game_over()
	queue_free()
