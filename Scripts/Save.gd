extends Node2D
var dict = {}
onready var load_node = get_node("/root/App/UI/HBoxContainer/Load")

func convert_dictionary(array):
	# Need the save_nodes to be a dictionary as the save data is a string
	for i in array:
		dict[str(i)] = i

func save_app():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:


		# Check the node has a save function
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file
		
		save_game.store_line(to_json(node_data))
		
	save_game.close()

func load_app():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
		print("Error no save to load. Saving")
		

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	convert_dictionary(save_nodes)

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
	
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		
		
		var node = get_node("/root/App/GroundFloor/CleaningArea").find_node(str(node_data["node"]))

		for i in node_data.keys():            
			if i == "filename" or i == "parent" or i == "node":
				continue			
			elif dict.has(node_data["node"]):
				dict[node_data["node"]].set(i, node_data[i])
	load_node.modulate = Color(0, 1, 0)
	save_game.close()
