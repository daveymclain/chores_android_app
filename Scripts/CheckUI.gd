extends Node2D

var node_testing = null
var mop_present = false
var mop_selected = false

func _ready():
	for node in get_tree().get_nodes_in_group("Persist"):
		node.connect("clicked", self, "_clicked")

func _clicked(node):
	self.position = Vector2(0, 0)
	mop_present = false
	$"VBoxContainer/Row mop".visible = false
	if node.get_node("Mop"):
		mop_present = true
		$"VBoxContainer/Row mop".visible = true
		print("gots the mops ", node.get_node("Mop").name, "\nThe node: ", node.name)
	else:
		mop_present = false
	node_testing = node
	$"VBoxContainer/Row mop/HBoxContainer/HooverButton".pressed = true
	$"VBoxContainer/Row mop/HBoxContainer/MopButton".pressed = false
	$"VBoxContainer/Row 1/CheckLabel".text = node.task_name



func _on_Yes_pressed():
	if $"VBoxContainer/Row mop/HBoxContainer/MopButton".pressed:
		node_testing.get_node("Mop").time_start = OS.get_unix_time()
	else:
		node_testing.time_start = OS.get_unix_time()
	Undo.add_input([node_testing, node_testing.time_start])

	node_testing.time_start = OS.get_unix_time()
	Save.save_app()
	exit_checkui()

func _on_No_pressed():
	exit_checkui()
	
func _on_Zoom_pressed():
	var ground_floor_node = get_node("/root/App/GroundFloor")
	ground_floor_node.scale = node_testing.zoom_settings["scale"]
	ground_floor_node.position = node_testing.zoom_settings["position"]
	exit_checkui()


func _on_HooverButton_toggled(button_pressed):
	if button_pressed:
		$"VBoxContainer/Row mop/HBoxContainer/MopButton".pressed = false
		$"VBoxContainer/Row 1/CheckLabel".text = node_testing.task_name
		mop_selected = false
	else:
		$"VBoxContainer/Row 1/CheckLabel".text = node_testing.get_node("Mop").task_name
		$"VBoxContainer/Row mop/HBoxContainer/MopButton".pressed = true
		mop_selected = true

func _on_MopButton_toggled(button_pressed):
	if button_pressed:
		$"VBoxContainer/Row mop/HBoxContainer/HooverButton".pressed = false
		$"VBoxContainer/Row 1/CheckLabel".text = node_testing.get_node("Mop").task_name
		mop_selected = true
	else:
		$"VBoxContainer/Row 1/CheckLabel".text = node_testing.task_name
		$"VBoxContainer/Row mop/HBoxContainer/HooverButton".pressed = true
		mop_selected = false

func exit_checkui():
	position = Vector2(0, -1000)
	$"VBoxContainer/Row mop".visible = false
	mop_selected = false
	node_testing = null


func change_heading(node):
	$"VBoxContainer/Row 1/CheckLabel".text = node.task_name
