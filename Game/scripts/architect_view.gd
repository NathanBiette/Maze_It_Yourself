extends CanvasLayer

var selected_room
var selected_monster
var selected_boss
var current_room = 0
const enemies = ["skeleton", "gorgon", "giant"]
const bosses = ["minotaure"]
const opacity = 0.5

func _ready():
	#set rooms menu
	get_node("map_selector/GridContainer/core_room_0").set_opacity(opacity)
	selected_room = 0
	#set monsters menu
	hide_monsters()
	get_node("monster_selector/GridContainer/skeleton").set_opacity(opacity)
	selected_monster = 0
	#set bosses menu
	hide_bosses()
	get_node("boss_selector/GridContainer/minotaure").set_opacity(opacity)
	selected_monster = 0

############################################SHOW HIDE MENUS#####################################
#show room menu
func show_rooms():
	get_node("map_selector").show()
	get_node("map_selector").set_ignore_mouse(false)
	get_node("add_room").show()
	get_node("add_room").set_ignore_mouse(false)

#hide monster menu
func hide_rooms():
	get_node("map_selector").set_hidden(true)
	get_node("map_selector").set_ignore_mouse(true)
	get_node("add_room").set_hidden(true)
	get_node("add_room").set_ignore_mouse(true)

#show monster menu
func show_monsters():
	get_node("monster_selector").show()
	get_node("monster_selector").set_ignore_mouse(false)
	get_node("add_monster").show()
	get_node("add_monster").set_ignore_mouse(false)

#hide monster menu
func hide_monsters():
	get_node("monster_selector").set_hidden(true)
	get_node("monster_selector").set_ignore_mouse(true)
	get_node("add_monster").set_hidden(true)
	get_node("add_monster").set_ignore_mouse(true)

#show boss menu
func show_bosses():
	get_node("boss_selector").show()
	get_node("boss_selector").set_ignore_mouse(false)
	get_node("add_boss").show()
	get_node("add_boss").set_ignore_mouse(false)

#hide boss menu
func hide_bosses():
	get_node("boss_selector").set_hidden(true)
	get_node("boss_selector").set_ignore_mouse(true)
	get_node("add_boss").set_hidden(true)
	get_node("add_boss").set_ignore_mouse(true)
################################################################################################

#################################ADD BUTTONS####################################################

func _on_add_room_pressed():
	get_node("../..").add_room(selected_room)
	hide_rooms()
	current_room += 1

func _on_add_monster_pressed():
	pass # replace with function body

func _on_add_boss_pressed():
	pass # replace with function body

func _on_release_pressed():
	pass # replace with function body

func _on_link_pressed():
	if get_node("../../..").connect_architect(current_room):
		show_rooms()

#############################################################################

#########################ROOMS FOCUS#########################################
func _on_core_room_0_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		change_focus(0)

func _on_core_room_1_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		change_focus(1)

func _on_core_room_2_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		change_focus(2)

func _on_core_room_3_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		change_focus(3)

func _on_core_room_4_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		change_focus(4)

func _on_core_room_5_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		change_focus(5)

func _on_core_room_6_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		change_focus(6)

func _on_core_room_7_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		change_focus(7)

func _on_core_room_8_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		change_focus(8)

func change_focus(room_number):
		get_node("map_selector/GridContainer/core_room_" + str(selected_room)).set_opacity(1.0)
		get_node("map_selector/GridContainer/core_room_" + str(room_number)).set_opacity(opacity)
		selected_room = room_number
################################################################################################

#################################MONSTER FOCUS####################################################
func _on_skeleton_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		get_node("monster_selector/GridContainer/" + enemies[selected_monster]).set_opacity(1.0)
		get_node("monster_selector/GridContainer/skeleton").set_opacity(opacity)
		selected_monster = 0

func _on_gorgon_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		get_node("monster_selector/GridContainer/" + enemies[selected_monster]).set_opacity(1.0)
		get_node("monster_selector/GridContainer/gorgon").set_opacity(opacity)
		selected_monster = 1


func _on_giant_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		get_node("monster_selector/GridContainer/" + enemies[selected_monster]).set_opacity(1.0)
		get_node("monster_selector/GridContainer/giant").set_opacity(opacity)
		selected_monster = 2
##############################################################################################


#################################BOSS FOCUS####################################################
func _on_minotaure_input_event(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON):
		get_node("boss_selector/GridContainer/" + bosses[selected_boss]).set_opacity(1.0)
		get_node("boss_selector/GridContainer/minotaure").set_opacity(opacity)
		selected_boss = 0
##############################################################################################