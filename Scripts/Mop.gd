extends Sprite

export var clean_frequency = {"days" : 0, "hours" : 1, "mins" : 0, "secs" : 0}
var time_start = 0
export var dirt_limit = 0.8
export var task_name = "Living room\nMop"
var ready = false

func _ready():
	add_to_group("Persist")
	if not Temp.loaded:
		time_start = OS.get_unix_time()

func _process(delta):
#	if get_node("/root/App").done and ready == false:
#		Save.dict_save[self] = {"time_start": time_start,
#		"clean_frequency" : clean_frequency}
#		ready = true
	if get_node("/root/App").done:
		var dirt_alpha = Methods.dirt_test(Save.dict_save[self]["clean_frequency"], 
				Save.dict_save[self]["time_start"], dirt_limit)[0]
	
		if not self.has_node("Flash"):
			modulate.a = dirt_alpha

func save():
	var save_dict = {
		"clean_frequency" : clean_frequency,
		"time_start" : time_start
	}
	return save_dict
