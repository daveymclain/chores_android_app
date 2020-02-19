extends Tween

var time = 1
var start_val = Color(1,1,1,1)
var end_val = Color(1,1,1,0)

func _ready():
	var parent_node = self.get_parent()
	interpolate_property(parent_node, "modulate", start_val, end_val, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	start()
	print("runing flash tween. parent = ", parent_node)

func _on_Flash_tween_completed(object, key):
	
	if start_val.a > 0:
		start_val.a = 0
	else:
		start_val.a = 1
	if end_val.a > 0:
		end_val.a = 0
	else:
		end_val.a = 1
	interpolate_property(self.get_parent(), "modulate", start_val, end_val, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	start()
