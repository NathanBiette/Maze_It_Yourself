extends Node2D

var original_pos
var direction = 0
var distance

const HERO_SPEED = 100

func _ready():
	original_pos = get_node(".").get_global_pos()
	set_process(true)

func move_up():
	if (direction == 0):
		distance = 100
		direction = 1

func move_down():
	if (direction == 0):
		distance = 100
		direction = 2

func move_left():
	if (direction == 0):
		distance = 100
		direction = 3

func move_right():
	if (direction == 0):
		distance = 100
		direction = 4

func _process(delta):
	var hero_pos = get_node(".").get_global_pos()
	var movelen = HERO_SPEED * delta
	
	if (direction == 1):
		hero_pos.y -= movelen
		distance -= movelen
		if (distance <= 0):
			direction = 0
			hero_pos.y -= direction
	
	if (direction == 2):
		hero_pos.y += movelen
		distance -= movelen
		if (distance <= 0):
			direction = 0
			hero_pos.y += direction
	
	if (direction == 3):
		hero_pos.x -= movelen
		distance -= movelen
		if (distance <= 0):
			direction = 0
			hero_pos.x += direction
	
	if (direction == 4):
		hero_pos.x += movelen
		distance -= movelen
		if (distance <= 0):
			direction = 0
			hero_pos.x -= direction
	
	get_node(".").set_global_pos(hero_pos)

func _on_swipe_gesture_swiped( gesture ):
	var dir = gesture.get_direction()
	if (dir=="up"):
		move_up()
	if (dir=="down"):
		move_down()
	if (dir=="left"):
		move_left()
	if (dir=="right"):
		move_right()

