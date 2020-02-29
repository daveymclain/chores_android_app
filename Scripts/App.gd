extends Node2D

var done = false
onready var save_nodes = get_tree().get_nodes_in_group("Persist")




func _ready():

	$StartDelay.start(1)
	if Engine.has_singleton("GodotLocalNotification"):
		var ln = Engine.get_singleton("GodotLocalNotification")
		ln.showLocalNotification("Message", "Title or application name", 20, 1)
		# 20 is an interval in seconds
		# 1 is a notification tag
		# you can override the notification with the same tag before it was fired
func _on_StartDelay_timeout():
	save_nodes = get_tree().get_nodes_in_group("Persist")
	var node_number = 0 
	for node in save_nodes:
		node.node_number = str(node_number)
		node_number += 1
	
	done = Save.load_save()
	

	if not done:
		# if you cant load from file generate working dictionary
		print("cant load generating dict")

		
		for node in save_nodes:
		# Check the node has a save function
			if !node.has_method("save"):
				print("persistent node '%s' is missing a save() function, skipped" % node.name)
				continue
			
			# Call the node's save function
			Save.dict_save[node.node_number] = node.call("save")

		
		Save.dict_save["save_time"] = 0
		done = true
		
