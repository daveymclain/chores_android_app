extends Node

var dict_save = {}
onready var server_node = get_node("/root/App/Server")

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
# convert string names from save file into node ojects
	for i in save_nodes:
		print("node number=", i.node_number)
		
		if i.node_number in dict_save.keys():
			dict_save[i.node_number]["node"] = i
		else:
			print("new node added")
			dict_save[i.node_number] = i.call("save")
			continue
	file.close()
	print("dict from load", dict_save)
	print("node amount: = ", len(save_nodes))
	return loaded

func save():
	print("saving to file")
	var file = File.new()
	file.open("user://savegame.save", File.WRITE)
	var save_time = OS.get_unix_time()
	dict_save["save_time"] = save_time
	file.store_line(to_json(dict_save))
	file.close()
	server_node.update_server()

