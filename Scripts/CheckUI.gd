extends Node2D

var node_testing = null



func _on_Yes_pressed():
	
	Undo.add_input([node_testing, node_testing.time_start])
	print(Undo.list_inputs)
	node_testing.time_start = OS.get_unix_time()
	position = Vector2(0, -1000)

func _on_No_pressed():
	
	position = Vector2(0, -1000)
