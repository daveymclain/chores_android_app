extends Node2D

export var link_node_number = "18"
var cron = 2
var last_update = 0
var parent_number = null


func _process(delta):
	cron -= delta
	if cron < 0:
		if parent_number == null:
			parent_number = get_parent().node_number
