extends Node

var dict_save = {}


func convert_dictionary(array):
	# Need the save_nodes to be a dictionary as the save data is a string
	var dict = {}
	for i in array:
		dict[str(i)] = i
	return dict
	
func load_save():
	var file = File.new()
	if not file.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
		print("Error no save to load. Saving")
	file.open("user://savegame.save", File.READ)
	var text = file.get_as_text()
	dict_save = parse_json(text)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	var dict = convert_dictionary(save_nodes)
	
	for i in dict_save.keys():
		if i == "save_time":
			continue
		dict_save[dict[i]] = dict_save[i]
		dict_save.erase(i)	
		

	file.close()

func save():
	var file = File.new()
	file.open("user://savegame.save", File.WRITE)
	var save_time = OS.get_unix_time()
	dict_save["save_time"] = save_time
	file.store_line(to_json(dict_save))
	file.close()

