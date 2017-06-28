extends Camera2D

var previous_pos

func _ready():
	previous_pos =  get_camera_pos()


func _on_swipe_swipe_updated( partial_gesture ):
	get_camera_pos() + 
