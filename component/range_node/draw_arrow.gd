extends DrawRequest
class_name DrawArrow

var start:Vector2
var min_l
var max_l

func _init(start_pos,min_length=0,max_length=INF) -> void:
	start=start_pos
	self.min_l=min_length
	self.max_l=max_length
