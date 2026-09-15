extends Node
class_name StatComponent
enum Type{HP,Enegy}

## emit on health change, delta: changed number
signal changed(from,to)
@export var type:Type
@export var max_value = 20
@export var min_value = 0
@export var value=10:
	set = set_value


func set_value(new_v):
	var old_value=value
	var new_value = clampi(new_v,min_value,max_value)
	value=new_value
	changed.emit(old_value,new_value)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	changed.emit.call_deferred(value,value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
