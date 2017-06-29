extends Node

const SLOW_TIMER = 5
const FAST_TIMER = 1
const GOLD_INCOME = 10
const MAGIC_INCOME = 2

var architect_gold = 100
var architect_magic = 20

var gold_timer
var income_speed = false

var websocket
onready var parent = get_node("..")

func _ready():
	gold_timer = Timer.new()
	gold_timer.set_wait_time(SLOW_TIMER)
	gold_timer.connect("timeout", self, "_on_gold_timeout")
	add_child(gold_timer)
	gold_timer.start()

func set_gold_income(speed):
	income_speed = speed

func set_gold_amount(gold_amount):
	architect_gold = gold_amount
	get_node("architect_floor/Camera2D/CanvasLayer/coin_sprite/coin_label").set_text(str(architect_gold))

func set_magic_amount(magic_amount):
	architect_magic = magic_amount
	get_node("architect_floor/Camera2D/CanvasLayer/magic_sprite/magic_label").set_text(str(architect_magic))

func _on_gold_timeout():
	gold_timer.stop()
	if income_speed:
		gold_timer.set_wait_time(FAST_TIMER)
	else:
		gold_timer.set_wait_time(SLOW_TIMER)
	gold_timer.start()
	architect_gold += GOLD_INCOME
	get_node("architect_floor/Camera2D/CanvasLayer/coin_sprite/coin_label").set_text(str(architect_gold))
	architect_magic += MAGIC_INCOME
	get_node("architect_floor/Camera2D/CanvasLayer/magic_sprite/magic_label").set_text(str(architect_magic))
	
func game_over():
	get_node("..").game_over()
	queue_free()