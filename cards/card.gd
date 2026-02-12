@tool
extends Button



@export var data: CardData:
	set(d):
		data=d
		_update_data()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _update_data():
	if not is_node_ready(): await  ready
	var description = data.ID+"_DESP"
	text=tr(description).format(data)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
