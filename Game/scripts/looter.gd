extends StaticBody2D

var location

func _ready():
	pass

func set_location(location_to_set):
	location = location_to_set

func give_loot(current_room):
	if (current_room == get_node("..").get_room_id()):
		get_node("../TileMap").set_cell(location[0],location[1],13)
		var lib = get_node("../../../..").get_ITEMS_LIBRARY()
		var k = randi()%lib.size()
		var item = load("res://scenes/game_hero/objects/"+str(lib[k][1])+".tscn")
		var item_instance = item.instance()
		get_node("..").add_child(item_instance)
		item_instance.set_pos(get_node(".").get_pos())
		print("free_truc")
		queue_free()