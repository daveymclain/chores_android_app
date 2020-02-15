extends Node2D

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
		print(node_data)
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_app():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
		print("Error no save to load. Saving")
		save_app()

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		get_tree().get_nodes_in_group("Persist")
		var node = get_node("/root/App/GroundFloor/CleaningArea").find_node(str(node_data["node"]))

		for i in node_data.keys():            
			if i == "filename" or i == "parent" or i == "node":
				continue			
			node.set(i, node_data[i])
	

	save_game.close()
