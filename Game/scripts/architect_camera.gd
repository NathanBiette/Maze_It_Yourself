extends Camera2D

var previous_swipe_point

func _ready():
	pass


func _on_swipe_swipe_updated(partial_gesture):
	set_pos(Vector2(get_pos().x - (partial_gesture.last_point().x - previous_swipe_point.x) , get_pos().y - (partial_gesture.last_point().y - previous_swipe_point.y)))
	previous_swipe_point = partial_gesture.last_point()

func _on_swipe_swipe_started( partial_gesture ):
	previous_swipe_point = partial_gesture.last_point()
