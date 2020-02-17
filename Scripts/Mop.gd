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
	if Methods.conver_sec(clean_frequency):
		modulate.a = Methods.dirt_test(clean_frequency, 
			time_start, dirt_limit)[0]
	else:
		modulate.a = 0

func save():
	var save_dict = {
		"node" : self,
		"clean_frequency" : clean_frequency,
		"time_start" : time_start
	}
	return save_dict
