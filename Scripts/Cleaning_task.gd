extends Area2D

signal clicked

# limit of transparancy
export var task_name = "Living room \nHoover"
export var dirt_limit = 0.8



export var zoom_settings = {"position": Vector2(0, -100), "scale": Vector2(1.6, 1.6)}
var active = true
# how often to clean days/hours
export var clean_frequency = {"days" : 0, "hours" : 0, "mins" : 1, "secs" : 0}
onready var dirt_node = find_node("Dirt")
var time_start = 0

var node_check = null

func _ready():
	
	set_process(true)
	add_to_group("Persist")
	if not Temp.loaded:
		time_start = OS.get_unix_time()
	
# warning-ignore:unused_argument
func _process(delta):
	if Methods.conver_sec(clean_frequency):
		dirt_node.modulate.a = Methods.dirt_test(clean_frequency, 
			time_start, dirt_limit)[0]
	else:
		find_node("Dirt").modulate.a = 0


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_LivingRoomHoover_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
		emit_signal("clicked", self)
		get_tree().set_input_as_handled()
		print("click ", self.name)
		
func save():
	var save_dict = {
		"node" : self,
		"clean_frequency" : clean_frequency,
		"time_start" : time_start
	}
	return save_dict
		