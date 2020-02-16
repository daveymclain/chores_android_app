extends Area2D


# limit of transparancy
export var task_name = "Living room \nHoover"
export var dirt_limit = 0.8
onready var node_check = get_node("/root/App/CheckUI")
export var zoom_settings = {"position": Vector2(0, -100), "scale": Vector2(1.6, 1.6)}
var active = true
# how often to clean days/hours
export var clean_frequency = {"days" : 0, "hours" : 0, "mins" : 1, "secs" : 0}
onready var dirt_node = find_node("Dirt")
var time_start = 0


func _ready():
	time_start = OS.get_unix_time()
	set_process(true)
	add_to_group("Persist")
	print("start up clean settings = ", clean_frequency)

	
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
	if (event is InputEventMouseButton && event.pressed):
		get_node("/root/App/CheckUI").find_node("CheckLabel").text = task_name + "?"
		node_check.position = Vector2(0, 0)
		node_check.node_testing = self
		
func save():
	var save_dict = {
		"node" : self.name,
		"clean_frequency" : clean_frequency,
		"time_start" : time_start
	}
	return save_dict
		
