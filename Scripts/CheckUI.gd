extends Node2D

var node_testing = null
var mop_present = false
var mop_selected = false
var mop_colour = Color(0, 0, 1)
var dirt_colour = Color(1, 0, 0)

func _ready():
	# Conect to all cleaning tasks click signals
	for node in get_tree().get_nodes_in_group("Persist"):
		node.connect("clicked", self, "_clicked")

func _clicked(node):
	Methods.flash_start(node.get_node("Dirt"), true)
	self.position = Vector2(0, 0)
	mop_present = false
	$"VBoxContainer/Row mop".visible = false
	if node.get_node("Mop"):
		mop_present = true
		$"VBoxContainer/Row mop".visible = true
	else:
		mop_present = false
	node_testing = node
	# Reset hoover and mop buttons.
	$"VBoxContainer/Row mop/HBoxContainer/HooverButton".pressed = true
	$"VBoxContainer/Row mop/HBoxContainer/MopButton".pressed = false
	
	$"VBoxContainer/Row 1/CheckLabel".text = node.task_name



func _on_Yes_pressed():
	if $"VBoxContainer/Row mop/HBoxContainer/MopButton".pressed:
		node_testing.get_node("Mop").time_start = OS.get_unix_time()
	else:
		node_testing.time_start = OS.get_unix_time()
	Undo.add_input([node_testing, node_testing.time_start])
	exit_checkui()
	Save.save_app()
	
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
		set_task_name(node_testing, dirt_colour)

		mop_selected = false
	else:
		set_task_name(node_testing.get_node("Mop"), mop_colour)
		$"VBoxContainer/Row mop/HBoxContainer/MopButton".pressed = true
		mop_selected = true

func _on_MopButton_toggled(button_pressed):
	if button_pressed:
		$"VBoxContainer/Row mop/HBoxContainer/HooverButton".pressed = false
		set_task_name(node_testing.get_node("Mop"), mop_colour)
		switch_selection(false)
		mop_selected = true
	else:
		set_task_name(node_testing, dirt_colour)
		$"VBoxContainer/Row mop/HBoxContainer/HooverButton".pressed = true
		switch_selection(true)
		mop_selected = false
	
func set_task_name(node, colour):
	$"VBoxContainer/Row 1/CheckLabel".text = node.task_name
	$"VBoxContainer/Row 1/CheckLabel".set("custom_colors/font_color", colour)

func _on_ColorRect_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
		exit_checkui()

func _on_Settings_pressed():
	if mop_selected:
		Methods.flash_start(node_testing.get_node("Mop"), false)
	else:
		Methods.flash_start(node_testing.get_node("Dirt"), false)

func switch_selection(dirt):
	if mop_selected:
		if dirt:
			Methods.flash_start(node_testing.get_node("Mop"), false)
			Methods.flash_start(node_testing.get_node("Dirt"), true)
		else:
			Methods.flash_start(node_testing.get_node("Dirt"), false)
			Methods.flash_start(node_testing.get_node("Mop"), true)
		
func exit_checkui():
	# Clean up when leaving menu
	
	if mop_selected:
		Methods.flash_start(node_testing.get_node("Mop"), false)
	else:
		Methods.flash_start(node_testing.get_node("Dirt"), false)
	position = Vector2(0, -1200)
	$"VBoxContainer/Row mop".visible = false
	mop_selected = false
	node_testing = null
