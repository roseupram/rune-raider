extends Node

var range_node:RangeLayer
var player_node:Player
	

func show_range(card:CardUI):
	if not range_node:
		push_warning("no range_node")
		return
	var d:CardData = card.data
	var r:RangeType=d.range
	var x_r = [-r.value,r.value+1]
	var center:Vector2i  = range_node.global_to_map(player_node.global_position)
	for i in range.callv(x_r):
		for j in range.callv(x_r):
			range_node.enable(center+Vector2i(i,j),r.tile_mask)
	
func clear_range():
	if not range_node:
		push_warning("no range_node")
		return
	range_node.clear()

func register_rangelayer(n:RangeLayer):
	range_node=n
	
