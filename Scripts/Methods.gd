extends Node2D

func conver_sec(list):
	var total = 0
	if list["days"] > 1:
		total += list["days"]  * 86400
	if list["hours"] > 0:
		total += list["hours"] * 3600
	if list["mins"] > 0:
		total += list["mins"] * 60
	
	return total + list["secs"]
	
func convert_percent_to_alpha(percent, alpha_limit):
	if percent < 100:
		var percent_alpha_limit = alpha_limit / 100
		return percent * percent_alpha_limit
	else:
		return alpha_limit

func dirt_test(sec, time_start, dirt_limit):
	var time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	var percent = 0
	var percent_complete = 0
	
	percent = float(sec) / 100		
	
	percent_complete =  elapsed / percent
	print(percent_complete, "%")

	return convert_percent_to_alpha(percent_complete, dirt_limit)
