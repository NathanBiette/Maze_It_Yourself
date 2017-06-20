extends Node

onready var godothub = preload('res://scripts/godothub.gd')
onready var conn = godothub.new()

func _ready():
	set_process(true)
	conn = godothub.new(5000,"137.194.22.216","2")

  # Connect to message signal of godothub to callback
	conn.connect("message",self,"_on_receive")

func _process(dt):

  # Listening for packet
	conn.is_listening()
	
	if (Input.is_action_pressed("ui_accept")):
		conn.broadcast_data("Welcome")
# Callback for receiving incoming packet
func _on_receive(data):
	print("Receive Data: ",data)


