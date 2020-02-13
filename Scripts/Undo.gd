extends Node2D

var list_inputs = []
var undo_position = 0

func add_input(input):
	self.list_inputs.insert(self.undo_position, input)
	self.undo_position = 0

func undo():
	if self.undo_position < self.list_inputs.size():
		var clean_area_node = self.list_inputs[undo_position][0]
		var last_time_start = self.list_inputs[undo_position][1]
		clean_area_node.time_start = last_time_start
		
		self.undo_position += 1
