extends Area2D

signal clicked

const Flash = preload("res://Scenes/Flash.tscn")
# limit of transparancy
export var task_name = "Living room \nHoover"
export var dirt_limit = 0.8
var node_number



export var zoom_settings = {"position": Vector2(0, -100), "scale": Vector2(1.6, 1.6)}
var active = true
# how often to clean days/hours
export var clean_frequency = {"days" : 0, "hours" : 0, "mins" : 1, "secs" : 0}
onready var dirt_node = self.get_node("Dirt")
var time_start = 0

var node_check = null

var ready = false

func _ready():
	add_to_group("Persist")

	
# warning-ignore:unused_argument
func _process(delta):
#	if get_node("/root/App").done and ready == false:
#		Save.dict_save[self] = {"time_start": time_start,
#		"clean_frequency" : clean_frequency}
#		ready = true
	if get_node("/root/App").done:
		var dirt_alpha = Methods.dirt_test(Save.dict_save[node_number]["clean_frequency"], 
				Save.dict_save[node_number]["time_start"], dirt_limit)[0]
	
		if not $Dirt.has_node("Flash"):
			dirt_node.modulate.a = dirt_alpha

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_LivingRoomHoover_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
		emit_signal("clicked", node_number)
		get_tree().set_input_as_handled()
	
func save():
	var save_dict = {
		"node" : self,
		"clean_frequency" : clean_frequency,
		"frequency_save" : 0,
		"time_start" : time_start
	}
	return save_dict

		
