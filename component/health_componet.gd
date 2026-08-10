extends Node
class_name StatComponent


## emit on health change, delta: changed number
signal changed(delta,current,max_v) 

@export var max_value = 20
@export var value=10:
	set = set_value


func set_value(new_v):
	var old_value=value
	var new_value = min(new_v,max_value)
	value=new_value
	var delta = new_value-old_value
	changed.emit(delta,new_value,max_value)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
