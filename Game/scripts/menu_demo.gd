extends Sprite

onready var parent = get_node("..")

func _ready():
	pass


func _on_start_hero_pressed():
	var game_hero = preload("res://scenes/game_hero/demo.tscn")
	var hero = game_hero.instance()
	get_node("..").add_child(hero)
	queue_free()

