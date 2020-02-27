extends Node2D

var ZOOM_OUT_POSITION = Vector2(0,0)
var ZOOM_OUT_SCALE = Vector2(1,1)
var zoomed = false
onready var ground_floor_node = get_node("/root/App/GroundFloor")

func _ready():
	for node in get_tree().get_nodes_in_group("Clickable"):
		node.connect("double_clicked", self, "_zoom")

func _zoom(node):
	if not zoomed:
		ground_floor_node.position = node.zoom_settings["position"]
		ground_floor_node.scale = node.zoom_settings["scale"]
		zoomed = true
	else:
		ground_floor_node.position = ZOOM_OUT_POSITION
		ground_floor_node.scale = ZOOM_OUT_SCALE
		zoomed = false
