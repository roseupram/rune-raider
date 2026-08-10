extends  ActionRequest
class_name HealRequest

var heal_value

func _init(ac,param):
	super._init(ac)
	heal_value=param.value

func execute():
	print("heal")
