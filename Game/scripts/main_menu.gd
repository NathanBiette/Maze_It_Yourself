extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_start_architect_pressed():
	pass # replace with function body


func _on_start_hero_pressed():
	get_tree().change_scene("res://scenes/game_hero/game_hero.tscn")


func _on_disconnect_pressed():
	pass # replace with function body


func _on_connect_hero_pressed():
	pass # replace with function body


func _on_connect_architect_pressed():
	pass # replace with function body
