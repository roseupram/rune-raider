extends EffectData
class_name AttackEffect

@export var value=6

func _init() -> void:
	tr_key="Attack_DESP"
func create_request(actor,param):
	return AttackRequest.new(actor,param)
