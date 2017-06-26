extends Node

var ingame = false # Used to check if the player is in-game or not
const ENEMY_LIBRARY = [[1,"skeleton"],[2,"giant"]]
const ITEMS_LIBRARY = [[1,"helmets/basic_helmet"],[2,"items/ambrosia_potion"],[3,"items/necklace"],[4,"shields/basic_shield"],[5,"shields/cronos_shield"],[6,"weapons/steel_sword"]]

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
func get_ITEMS_LIBRARY():
	return ITEMS_LIBRARY