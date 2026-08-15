extends EffectData
class_name HealEffect

@export var range =0
@export var value=3

func _init() -> void:
	tr_key="Heal_DESP"
func create_request(actor,param:Dictionary):
	return HealRequest.new(actor,param.merged({value=value}))
