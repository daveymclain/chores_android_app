extends Button


var ground_floor = true
onready var top_floor_node = get_node("/root/App/TopFloor")
onready var ground_floor_node = get_node("/root/App/GroundFloor")


func _on_Top_Floor_pressed():
	if ground_floor:
		top_floor_node.scale = Vector2(1,1)
		text = "Top Floor"
		get_node("/root/App/GroundFloor").position = Vector2(1000, 0)
		get_node("/root/App/TopFloor").position = Vector2(0, 0)
		ground_floor = false
	else:
		ground_floor_node.scale = Vector2(1,1)
		text = " Ground Floor "
		get_node("/root/App/GroundFloor").position = Vector2(0, 0)
		get_node("/root/App/TopFloor").position = Vector2(1000, 0)
		ground_floor = true


func _on_Zoomout_pressed():
	print("ground floor = ", ground_floor)
	if not ground_floor:
		top_floor_node.scale = Vector2(1,1)
		top_floor_node.position = Vector2(0,0)
	else:
		ground_floor_node.scale = Vector2(1,1)
		ground_floor_node.position = Vector2(0,0)
