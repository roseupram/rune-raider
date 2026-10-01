extends Control
class_name CardFlow
@export var flow_node:HFlowContainer
@export var card_datas:Array[CardData]=[]:
	set(d):
		card_datas=d
		update_cards()
const CARD_FLOW_ITEM = preload("uid://bw0bnkd0bjduu")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_cards()
	
func sort(fn):
	pass

func update_cards():
	if not is_node_ready(): await ready
	for c in flow_node.get_children():
		c.queue_free()
	for d in card_datas:
		var card_item:CardFlowItem=CARD_FLOW_ITEM.instantiate()
		card_item.card_data=d
		flow_node.add_child(card_item)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
