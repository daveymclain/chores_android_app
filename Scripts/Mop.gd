extends Sprite

export var clean_frequency = {"days" : 0, "hours" : 0, "mins" : 0, "secs" : 0}
var time_start = 0
export var dirt_limit = 0.8
export var task_name = "Living room\nMop"
var ready = false
var node_number
var percentage = 0

func _ready():
	add_to_group("Persist")

func _process(delta):

	if get_node("/root/App").done:
		var dirt_test = Methods.dirt_test(Save.dict_save[node_number]["clean_frequency"], 
				Save.dict_save[node_number]["time_start"], dirt_limit)
		percentage = dirt_test[1]
		if not self.has_node("Flash"):
			self.modulate.a = dirt_test[0]

func save():
	var save_dict = {
		"node" : self,
		"clean_frequency" : clean_frequency,
		"frequency_save" : 0,
		"time_start" : time_start,
		"override" : false,
		"name" : self.name
	}
	return save_dict
