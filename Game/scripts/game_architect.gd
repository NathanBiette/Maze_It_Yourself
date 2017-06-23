extends Node

var websocket
onready var parent = get_node("..")

const ENEMY_LIBRARY = [[1,"skeleton"],[2,"gorgon"]]

func _ready():
	websocket = parent.websocket

func get_ENEMY_LIBRARY():
	return ENEMY_LIBRARY



