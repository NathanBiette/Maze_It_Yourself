extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass



func _on_swipe_gesture_swiped( gesture ):
	var dir = gesture.get_direction()
	if (dir=="up"):
		get_node(".").set_global_pos(get_node(".").get_global_pos() + Vector2(0,-50))
	if (dir=="down"):
		get_node(".").set_global_pos(get_node(".").get_global_pos() + Vector2(0,50))
	if (dir=="left"):
		get_node(".").set_global_pos(get_node(".").get_global_pos() + Vector2(-50,0))
	if (dir=="right"):
		get_node(".").set_global_pos(get_node(".").get_global_pos() + Vector2(50,0))

