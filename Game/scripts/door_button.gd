extends TextureButton

var door_button_id=[0,0]
var door_button_type = "west"

signal pressed_button(button)

func _ready():
	pass

func get_door_button_id():
	return door_button_id

func set_door_button_id(room, door):
	door_button_id[0] = room
	door_button_id[1] = door


func _on_TextureButton_pressed():
	emit_signal("pressed_button", self)
