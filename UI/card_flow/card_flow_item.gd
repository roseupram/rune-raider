extends Control
class_name CardFlowItem

@export var img_node:TextureRect
@export var name_node:Label
@export var desp_node:Label

@export var card_data:CardData:
	set(d):
		card_data=d
		_update_data()
		
func _update_data():
	if not is_node_ready(): await  ready
	img_node.texture=card_data.image
	name_node.text=card_data.ID
	var desp_str = ""
	for e in card_data.effects:
		var description = e.tr_key.to_upper()
		desp_str+=tr(description).format(e)
	desp_node.text=desp_str
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
