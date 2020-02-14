extends Button



func _on_ZoomIn_pressed():
	get_node("/root/App/GroundFloor").scale = Vector2(1, 1)
	get_node("/root/App/GroundFloor").position = Vector2(0, 0)
