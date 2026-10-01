extends  Node
class_name TurnValue

signal changed(from,to)

@export var base_value=3

var value:
	set(v):
		var old_value = value
		value=v
		changed.emit(old_value,value)

func  _ready() -> void:
	EventBus.turn_start.connect(_on_turn_start)
	value=base_value
	changed.emit.call_deferred(value,value)

func _on_turn_start():
	value = base_value
