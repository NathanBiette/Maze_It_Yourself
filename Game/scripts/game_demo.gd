extends Node

var ingame = false # Used to check if the player is in-game or not
const ENEMY_LIBRARY = [[1,"skeleton"],[2,"giant"]]

func _ready():
	var main_menu = preload('res://scenes/menu_demo.tscn')
	var menu = main_menu.instance()
	get_node(".").add_child(menu)

func game_over():
	var main_menu = preload('res://scenes/menu_demo.tscn')
	var menu = main_menu.instance()
	self.add_child(menu)

func get_ENEMY_LIBRARY():
	return ENEMY_LIBRARY