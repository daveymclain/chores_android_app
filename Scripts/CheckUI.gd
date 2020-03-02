extends Node2D

var node_testing = null
var node_numbers = null
var mop_present = false
var mop_selected = false
var mop_colour = Color(0, 0, 1)
var dirt_colour = Color(1, 0, 0)
onready var UI_node = get_node("/root/App/UI")
onready var percentage_bar = $RowBar/ProgressBar

func _ready():
	# Conect to all cleaning tasks click signals
	for node in get_tree().get_nodes_in_group("Persist"):
		node.connect("clicked", self, "_clicked")

func _clicked(node_number):
	UI_node.visible = false
	get_node("/root/App/Server").server_paused = true
	self.position = Vector2(0, 0)
	mop_present = false
	$"Row mop".visible = false
	$"Row 1".visible = true
	if Save.dict_save[node_number]["node"].get_node("Mop"):
		mop_present = true
		$"Row mop".visible = true
		$"Row 1".visible = false
	else:
		mop_present = false
		
	node_numbers = node_number
	print(node_number)
	node_testing = Save.dict_save[node_number]["node"]
	# Reset hoover and mop buttons.
	$"Row mop/HBoxContainer/HooverButton".pressed = false
	$"Row mop/HBoxContainer/MopButton".pressed = true
	
	$"Row 1/CheckLabel".text = node_testing.task_name
	Methods.flash_start(node_testing.get_node("Dirt"), true)
	percentage_bar.value = node_testing.percentage
	
	


func _on_Yes_pressed():
	if not $"Row mop/HBoxContainer/MopButton".pressed:
		var num = node_testing.get_node("Mop").node_number
		Save.dict_save[num]["time_start"] = OS.get_unix_time()
	else:
		Save.dict_save[node_numbers]["time_start"] = OS.get_unix_time()
#	Undo.add_input([node_testing, node_testing.time_start])
	exit_checkui()
	Save.save()
	Save.dict_save[node_numbers]["override"] = false
	
	
func _on_No_pressed():
	exit_checkui()
	
func _on_Zoom_pressed():
	var ground_floor_node = get_node("/root/App/GroundFloor")
	ground_floor_node.scale = node_testing.zoom_settings["scale"]
	ground_floor_node.position = node_testing.zoom_settings["position"]
	exit_checkui()


func _on_HooverButton_toggled(button_pressed):
	print("hoover button ", button_pressed)
	if button_pressed:
		$"Row mop/HBoxContainer/MopButton".pressed = false
	else:
		
		$"Row mop/HBoxContainer/MopButton".pressed = true
		

func _on_MopButton_toggled(button_pressed):
	print("mop button ", button_pressed)
	if button_pressed:
		$"Row mop/HBoxContainer/HooverButton".pressed = false
		switch_selection(true)
		mop_selected = false
	else:
		$"Row mop/HBoxContainer/HooverButton".pressed = true
		switch_selection(false)
		mop_selected = true

func switch_selection(dirt):
	
	if mop_present:
		if dirt:
			percentage_bar.value = node_testing.percentage
			Methods.flash_start(node_testing.get_node("Mop"), false)
			Methods.flash_start(node_testing.get_node("Dirt"), true)
		else:
			percentage_bar.value = node_testing.get_node("Mop").percentage
			Methods.flash_start(node_testing.get_node("Dirt"), false)
			Methods.flash_start(node_testing.get_node("Mop"), true)



func set_task_name(node, colour):
	$"Row 1/CheckLabel".text = node.task_name
	$"Row 1/CheckLabel".set("custom_colors/font_color", colour)

func _on_ColorRect_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
		exit_checkui()


func _on_Settings_pressed():
	UI_node.visible = true
	if mop_selected:
		Methods.flash_start(node_testing.get_node("Mop"), false)
	else:
		Methods.flash_start(node_testing.get_node("Dirt"), false)
	


func exit_checkui():
	# Clean up when leaving menu
	UI_node.visible = true
	if mop_selected:
		Methods.flash_start(node_testing.get_node("Mop"), false)
	else:
		Methods.flash_start(node_testing.get_node("Dirt"), false)
	position = Vector2(0, -1200)
	$"Row mop".visible = false
	mop_selected = false
	get_node("/root/App/Server").server_paused = false
