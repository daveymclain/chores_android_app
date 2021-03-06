extends Node2D

func conver_sec(list):
	var total = 0
	if list["days"] >= 1:
		total += list["days"]  * 86400
	if list["hours"] > 0:
		total += list["hours"] * 3600
	if list["mins"] > 0:
		total += list["mins"] * 60
	
	return total + list["secs"]
	
func time_left(sec_left):
	var mins = int(sec_left) / 60
	var hours = mins / 60
	var days_total = hours / 24
	mins -= (days_total * 1440)
	var hours_total = mins / 60
	var mins_total =  mins % 60
	return [days_total, hours_total, mins_total]
	
	
func convert_percent_to_alpha(percent, alpha_limit):
	
	if percent < 100:
		var ease_percent = ease(percent / 100, 5)
		
		var percent_alpha_limit = alpha_limit / 100
		
		return (ease_percent * 100) * percent_alpha_limit
	else:
		return alpha_limit
		

func dirt_test(time_dict, time_start, dirt_limit):
	var sec = conver_sec(time_dict)
	var time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	var sec_left = sec - elapsed
	if not sec == 0:

		var percent = 0
		var percent_complete = 0
		
		percent = float(sec) / 100		
		
		percent_complete =  elapsed / percent
		return [convert_percent_to_alpha(percent_complete, dirt_limit) , 
				percent_complete, sec_left]
	else:
		return [0, 0, sec_left]
	

func flash_start(node, start):
	
	if start:
		var Flash = preload("res://Scenes/Flash.tscn")
		var flash = Flash.instance()
		node.add_child(flash)
	elif node.has_node("Flash"):
		node.get_node("Flash").queue_free()
