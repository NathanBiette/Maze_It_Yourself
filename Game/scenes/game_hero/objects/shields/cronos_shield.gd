extends KinematicBody2D

const defense = 1
var timeStopped = false
#var position

signal timer_end

func _ready():
	pass

func defense():
	return defense

func active(current_room):
	current_room.set_pause_room(true)
	_wait(3)
	current_room.set_pause_room(false)
	

func _on_Area2D_area_enter(area):
	var interacting_node = area.get_node("../")
	if (interacting_node.get_name() == "theseus"):
		interacting_node.pick_up("cronos_shield", "shields")
		get_node(".").get_parent().kill(get_node("."))

func _wait( seconds ):
    self._create_timer(self, seconds, true, "_emit_timer_end_signal")
    yield(self,"timer_end")

func _emit_timer_end_signal():
    emit_signal("timer_end")

func _create_timer(object_target, float_wait_time, bool_is_oneshot, string_function):
    var timer = Timer.new()
    timer.set_one_shot(bool_is_oneshot)
    timer.set_timer_process_mode(0)
    timer.set_wait_time(float_wait_time)
    timer.connect("timeout", object_target, string_function)
    self.add_child(timer)
    timer.start()