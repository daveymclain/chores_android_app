extends Node2D

var node = null
var node_number
var changed = false
var changed_delay = false

func _process(delta):
	if not node == null:
		update_time_left()

func _on_Settings_pressed():
	get_node("/root/App/Server").server_paused = true
	get_node("/root/App/GroundFloor").position = Vector2(-700, 0)
	get_node("/root/App/CheckUI").position = Vector2(0, -1200)
	get_node("/root/App/UI").visible = false
	self.position = Vector2(0, 0)
	node = get_node("/root/App/CheckUI")
	if node.mop_selected:
		node_number = node.node_testing.get_node("Mop").node_number
	else:
		node_number = node.node_testing.node_number
	find_node("TaskText").text = Save.dict_save[node_number]["node"].task_name
	# Day Row
	find_node("DaysText").text = str(Save.dict_save[node_number]["clean_frequency"]["days"])
	find_node("DaySlider").value = Save.dict_save[node_number]["clean_frequency"]["days"]
	# Hours Row
	find_node("HoursText").text = str(Save.dict_save[node_number]["clean_frequency"]["hours"])
	find_node("HoursSlider").value = Save.dict_save[node_number]["clean_frequency"]["hours"]
	# Hours Row
	find_node("MinsText").text = str(Save.dict_save[node_number]["clean_frequency"]["mins"])
	find_node("MinsSlider").value = Save.dict_save[node_number]["clean_frequency"]["mins"]
	changed_delay = true

func _on_DaySlider_value_changed(value):
	Save.dict_save[node_number]["clean_frequency"]["days"] = int(value)
	Save.dict_save[node_number]["frequency_save"] = OS.get_unix_time()
	find_node("DaysText").text = str(value)
	if changed_delay:
		changed = true


func _on_HoursSlider_value_changed(value):
	Save.dict_save[node_number]["clean_frequency"]["hours"] = int(value)
	Save.dict_save[node_number]["frequency_save"] = OS.get_unix_time()
	find_node("HoursText").text = str(value)
	if changed_delay:
		changed = true

func _on_MinsSlider_value_changed(value):
	Save.dict_save[node_number]["clean_frequency"]["mins"] = int(value)
	Save.dict_save[node_number]["frequency_save"] = OS.get_unix_time()
	find_node("MinsText").text = str(value)
	if changed_delay:
		changed = true

func update_time_left():
	var time_left = Methods.time_left(Methods.dirt_test(Save.dict_save[node_number]["clean_frequency"], 
		Save.dict_save[node_number]["time_start"], Save.dict_save[node_number]["node"].dirt_limit)[2])
	var output_string = "Day: %02d\nHour: %02d\nMin %02d" % time_left
	find_node("TimeLeftText").text = str(output_string)

func _on_Exit_pressed():
	self.position = Vector2(-700, 0)
	get_node("/root/App/Server").server_paused = false
	get_node("/root/App/GroundFloor").position = Vector2(0, 0)
	get_node("/root/App/UI").visible = true
	get_node("/root/App/CheckUI").mop_selected = false
	changed_delay = false
	if changed:
		print_debug("Settings changed")
		Save.save()
		changed = false
