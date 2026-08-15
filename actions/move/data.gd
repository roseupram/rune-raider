extends EffectData
class_name MoveEffect
# straight line move, can not over obstacle


func _init() -> void:
	tr_key="MOVE_DESP"
func create_request(actor,param):
	return MoveRequest.new(actor,param)
