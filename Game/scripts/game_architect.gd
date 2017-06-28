extends Node

const SLOW_GOLD = 10
const FAST_GOLD = 20

var architect_gold = 0
var gold_speed = false
var gold_timer
var websocket
onready var parent = get_node("..")

func _ready():
	gold_timer = Timer.new()
	gold_timer.set_wait_time(1)
	gold_timer.connect("timeout", self, "_on_gold_timeout")
	add_child(gold_timer)
	gold_timer.start()

func _on_gold_timeout():
	gold_timer.stop()
	gold_timer.set_wait_time(1)
	gold_timer.start()
	var gold
	if gold_speed:
		gold = FAST_GOLD
	else:
		gold = SLOW_GOLD
	architect_gold += gold
	get_node("architect_floor/Camera2D/CanvasLayer/coin_sprite/coin_label").set_text(str(architect_gold))