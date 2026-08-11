extends  ActionRequest
class_name AttackRequest

var target_pos

func _init(ac,param):
	super._init(ac)
	target_pos=param.target_pos

func execute():
	print("attack")
	if actor.has_method("attack"):
		actor.attack(target_pos)
