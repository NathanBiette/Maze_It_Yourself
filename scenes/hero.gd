extends Node2D

var original_pos
var direction = 0
var distance

const HERO_SPEED = 50

func _ready():
	original_pos = get_node(".").get_global_pos()
	set_process(true)

func move_up():
	if (direction == 0):
		distance = 50
		direction = 1

func move_down():
	if (direction == 0):
		distance = 50
		direction = 2

func move_left():
	if (direction == 0):
		distance = 50
		direction = 3

func move_right():
	if (direction == 0):
		distance = 50
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
	
	if (Input.is_action_pressed("move_up")):
		move_up()
	
	if (Input.is_action_pressed("move_down")):
		move_down()
	
	if (Input.is_action_pressed("move_left")):
		move_left()
	
	if (Input.is_action_pressed("move_right")):
		move_right()
	
	get_node(".").set_global_pos(hero_pos)