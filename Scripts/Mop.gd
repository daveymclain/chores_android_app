extends Sprite

export var clean_frequency = {"days" : 0, "hours" : 1, "mins" : 0, "secs" : 0}
var time_start = 0
export var dirt_limit = 0.8
export var task_name = "Living room\nMop"

func _ready():
	set_process(true)
	add_to_group("Persist")
	if not Temp.loaded:
		time_start = OS.get_unix_time()

func _process(delta):
	var dirt_alpha = Methods.dirt_test(clean_frequency, 
			time_start, dirt_limit)[0]

	if not self.has_node("Flash"):
		modulate.a = dirt_alpha

func save():
	var save_dict = {
		"node" : self,
		"clean_frequency" : clean_frequency,
		"time_start" : time_start,
		"node_name" : self.name
	}
	return save_dict
