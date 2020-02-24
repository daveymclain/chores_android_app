extends Node2D

var node = null

func _process(delta):
	if not node == null:
		update_time_left()

func _on_Settings_pressed():
	get_node("/root/App/GroundFloor").position = Vector2(-700, 0)
	get_node("/root/App/CheckUI").position = Vector2(0, -1200)
	get_node("/root/App/UI").visible = false
	self.position = Vector2(0, 0)
	node = get_node("/root/App/CheckUI")
	if node.mop_selected:
		node = node.node_testing.get_node("Mop")
	else:
		node = node.node_testing
	find_node("TaskText").text = node.task_name
	# Day Row
	find_node("DaysText").text = str(Save.dict_save[node]["clean_frequency"]["days"])
	find_node("DaySlider").value = Save.dict_save[node]["clean_frequency"]["days"]
	# Hours Row
	find_node("HoursText").text = str(Save.dict_save[node]["clean_frequency"]["hours"])
	find_node("HoursSlider").value = Save.dict_save[node]["clean_frequency"]["hours"]
	# Hours Row
	find_node("MinsText").text = str(Save.dict_save[node]["clean_frequency"]["mins"])
	find_node("MinsSlider").value = Save.dict_save[node]["clean_frequency"]["mins"]

func _on_DaySlider_value_changed(value):
	Save.dict_save[node]["clean_frequency"]["days"] = int(value)
	find_node("DaysText").text = str(value)


func _on_HoursSlider_value_changed(value):
	Save.dict_save[node]["clean_frequency"]["hours"] = int(value)
	find_node("HoursText").text = str(value)


func _on_MinsSlider_value_changed(value):
	Save.dict_save[node]["clean_frequency"]["mins"] = int(value)
	find_node("MinsText").text = str(value)

func update_time_left():
	var time_left = Methods.time_left(Methods.dirt_test(Save.dict_save[node]["clean_frequency"], 
		Save.dict_save[node]["time_start"], node.dirt_limit)[2])
	var output_string = "Day: %02d\nHour: %02d\nMin %02d" % time_left
	find_node("TimeLeftText").text = str(output_string)

func _on_Exit_pressed():
	self.position = Vector2(-700, 0)
	get_node("/root/App/GroundFloor").position = Vector2(0, 0)
	get_node("/root/App/UI").visible = true
	Save.save()
