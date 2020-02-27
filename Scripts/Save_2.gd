extends Node

var dict_save = {}


func convert_dictionary(array):
	# Need the save_nodes to be a dictionary as the save data is a string
	var dict = {}
	for i in array:
		dict[str(i)] = i
	return dict
	
func load_save():
	var loaded = true
	var file = File.new()
	if not file.file_exists("user://savegame.save"):
		print("Error no save to load. Saving")
		loaded = false
		return loaded
		
	file.open("user://savegame.save", File.READ)
	
	dict_save = parse_json(file.get_line())
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	
	for i in save_nodes:

		if len(dict_save) > int(i.node_number):
			dict_save[i.node_number]["node"] = i
			
		else:
			print("new node added")
			dict_save[i.node_number] = i.call("save")
			continue

	file.close()
	return loaded

func save():
	var file = File.new()
	file.open("user://savegame.save", File.WRITE)
	var save_time = OS.get_unix_time()
	dict_save["save_time"] = save_time
	file.store_line(to_json(dict_save))
	file.close()

