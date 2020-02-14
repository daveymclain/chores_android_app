extends Node2D

var node_testing = null



func _on_Yes_pressed():
	
	Undo.add_input([node_testing, node_testing.time_start])
	print(Undo.list_inputs)
	node_testing.time_start = OS.get_unix_time()
	position = Vector2(0, -1000)

func _on_No_pressed():
	
	position = Vector2(0, -1000)


func _on_Zoom_pressed():
	var ground_floor_node = get_node("/root/App/GroundFloor")
	ground_floor_node.scale = node_testing.zoom_settings["scale"]
	ground_floor_node.position = node_testing.zoom_settings["position"]
	position = Vector2(0, -1000)
