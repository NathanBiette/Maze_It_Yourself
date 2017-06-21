extends Node

onready var godothub = preload('res://scripts/godothub.gd')
onready var conn = godothub.new()

func _ready():
	set_process(true)
	conn = godothub.new(5000,"137.194.22.177")

  # Connect to message signal of godothub to callback
	conn.connect("message",self,"_on_receive")

func _process(dt):

  # Listening for packet
	conn.is_listening()

# Callback for receiving incoming packet
func _on_receive(data):
	print("Receive Data: ",data)


func _on_pingButton_pressed():
	conn.broadcast_data({"string":"Hello"})


func _on_disconnectButton_pressed():
	conn.disconnect()


func _on_connectButton_pressed():
	conn = godothub.new(5000,"137.194.22.177")

  # Connect to message signal of godothub to callback
	conn.connect("message",self,"_on_receive")
