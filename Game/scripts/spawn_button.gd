extends TextureButton

var spawn_button_id=[0,0]

signal pressed_button(button)

func _ready():
	pass

func get_spawn_button_id():
	return spawn_button_id

func set_spawn_button_id(room, spawn):
	spawn_button_id[0] = room
	spawn_button_id[1] = spawn


func _on_TextureButton_pressed():
	emit_signal("pressed_button", self)
