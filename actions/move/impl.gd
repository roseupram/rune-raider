extends  ActionRequest
class_name MoveRequest

var target_position:Vector2
var from:Vector2

func _init(ac,param):
	var pos = param.target
	super._init(ac)
	target_position=pos

func execute():
	from=actor.global_position
	await  actor.move_to(target_position)
