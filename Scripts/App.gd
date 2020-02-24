extends Node2D

var done = false

func _ready():
	$StartDelay.start(1)

func _on_StartDelay_timeout():
	Save.load_save()
	done = true	
	
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for node in save_nodes:
#	# Check the node has a save function
#		if !node.has_method("save"):
#			print("persistent node '%s' is missing a save() function, skipped" % node.name)
#			continue
#
#		# Call the node's save function
#		Save.dict_save[node] = ""
#	done = true

