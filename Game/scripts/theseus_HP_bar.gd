extends ProgressBar

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var HP_info = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	#HP_info is a vector2 containingat index 0 int max_HP and at index 1 int current_HP
	var HP_info = get_node("../../.").get_HP()
	set_max(HP_info[0])
	set_value(HP_info[1])
	set_process(true)

func _process(delta):
	HP_info = get_node("../../.").get_HP()
	set_max(HP_info[0])
	set_value(HP_info[1])