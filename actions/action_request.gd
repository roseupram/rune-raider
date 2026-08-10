class_name ActionRequest
extends RefCounted

var actor:Node2D
var timestamp: float

func _init(ac):
	actor=ac
	timestamp=Time.get_ticks_msec()

func execute():
	assert(false,"not defined execute() of ActionRequest")
