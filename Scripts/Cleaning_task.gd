extends Area2D

signal clicked
signal double_clicked

const Flash = preload("res://Scenes/Flash.tscn")
# limit of transparancy
export var task_name = "Living room \nHoover"
export var dirt_limit = 0.8
var node_number

# double click stuff
var timer
var timer_on = false
var click_buffer = []

export var zoom_settings = {"position": Vector2(0, -100), "scale": Vector2(1.6, 1.6)}
var active = true
# how often to clean days/hours
export var clean_frequency = {"days" : 0, "hours" : 0, "mins" : 1, "secs" : 0}
onready var dirt_node = self.get_node("Dirt")

var time_start = 0
var percentage = 0
var node_check = null

var ready = false

func _ready():
	add_to_group("Persist")
	add_to_group("Clickable")

	
# warning-ignore:unused_argument
func _process(delta):

	if get_node("/root/App").done:
		var dirt_test = Methods.dirt_test(Save.dict_save[node_number]["clean_frequency"], 
				Save.dict_save[node_number]["time_start"], dirt_limit)
		percentage = dirt_test[1]
		if not $Dirt.has_node("Flash"):
			dirt_node.modulate.a = dirt_test[0]

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_LivingRoomHoover_input_event(viewport, event, shape_idx):
	
		if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
			click_buffer.append(event)
			if not timer_on:
				print("clcik timer started")
				timer = Timer.new()
				timer.one_shot = true
				timer.connect("timeout", self, "_timer_callback")
				add_child(timer)
				timer.start(.4)
				timer_on = true



func _timer_callback():
	print("click timer finished")
	print("Click buffer: = ", click_buffer)
	
	var last_event 
	if OS.get_name() == "Android" and len(click_buffer) > 1:
		last_event = click_buffer[-2]
	else:
		last_event = click_buffer[-1]
	print("last event = ", last_event)
	if (last_event is InputEventMouseButton && last_event.pressed && last_event.button_index == BUTTON_LEFT
		and not last_event.doubleclick):
		emit_signal("clicked", node_number)
		print("single click")
	if last_event is InputEventMouseButton and last_event.doubleclick:
		emit_signal("double_clicked", self)
		print("double clicked")
	click_buffer = []
	timer.queue_free()
	timer_on = false

func save():
	var save_dict = {
		"name" : self.name,
		"node" : self,
		"time_start" : time_start,
		"clean_frequency" : clean_frequency,
		"frequency_save" : 0,
		"override" : false,
		"override_time" : 0
	}
	return save_dict

		
