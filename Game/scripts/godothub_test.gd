extends Node

onready var godothub = preload('res://scripts/godothub.gd')
onready var conn = godothub.new()

func _ready():
	set_process(true)

func _process(dt):

  # Listening for packet
	conn.is_listening()

# Callback for receiving incoming packet
func _on_receive(data):
	print("Receive Data: ",data)

func _on_lobbyrequest(list):
	print("Hello " + list)

func _on_pingButton_pressed():
	conn.lobby_request()


func _on_disconnectButton_pressed():
	conn.disconnect()
	get_node("Panel/Label").set_text("disconnected")


func _on_connectButton_pressed():
	conn = godothub.new(5000,"137.194.22.177","0")

  # Connect to message signal of godothub to callback
	conn.connect("message",self,"_on_receive")
	get_node("Panel/Label").set_text("connected on channel 0")


func _on_channgeChannelButton_pressed():
	print("Button pressed")
	if (conn.client.channel == "0"):
		conn.change_channel("1")
		get_node("Panel/Label").set_text("connected on channel 1")
		print("switched channel")
	elif (conn.client.channel == "1"):
		conn.change_channel("0")
		get_node("Panel/Label").set_text("connected on channel 0")
		print("switched channel")
