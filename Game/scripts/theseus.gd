extends Node2D

var original_pos
var direction = 0
var distance

const HERO_SPEED = 50

func _ready():
	original_pos = get_node(".").get_global_pos()
	set_process(true)

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
	




