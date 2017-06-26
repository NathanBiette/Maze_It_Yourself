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
		print(k)
		level_instance.add_room(k)
	
	

func game_over():
	get_node("..").game_over()
	queue_free()
