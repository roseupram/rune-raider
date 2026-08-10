extends EffectData
class_name JumpEffect
# straight line move, can not over obstacle
@export var range =3

func _init() -> void:
	tr_key="Jump_DESP"
func create_request(actor,param):
	return JumpRequest.new(actor,param)
