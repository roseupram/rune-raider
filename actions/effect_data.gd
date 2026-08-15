extends Resource
class_name EffectData

@export_flags_2d_navigation var tile_mask
@warning_ignore("shadowed_global_identifier")
@export var range =1.0

const SCALE=128

#@export_flags("Free","Occupied","Player") var tile_mask
var tr_key="UNKONWN_DESP"
var scaled_range:
	get():
		return range*SCALE

func create_request(_ac,_params:Dictionary)->ActionRequest:
	assert(false,"not defined in EffectData")
	return 
