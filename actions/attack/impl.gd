extends  ActionRequest
class_name AttackRequest

var target_node

func _init(ac,param):
	var pos = param.target
	super._init(ac)
	target_node=pos

func execute():
	print("attack")
