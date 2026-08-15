extends RefCounted
class_name BattleManager

var range_node:RangeLayer
var player_node:Player
var card_manager:CardManager
var selected_card_data:CardData
var AM:ActionManager

func show_range(card:CardUI):
	if not range_node:
		push_warning("no range_node")
		return
	var d:CardData = card.data
	var tile_mask=d.effects[0].tile_mask
	var r=d.effects[0].range
	var x_r = [-r,r+1]
	var center:Vector2i  = range_node.global_to_map(player_node.global_position)
	for i in range.callv(x_r):
		for j in range.callv(x_r):
			range_node.enable(center+Vector2i(i,j),tile_mask)
	
func clear_range():
	if not range_node:
		push_warning("no range_node")
		return
	range_node.idle()

func _on_card_focus(c:CardUI,by_shortcut):
	show_range(c)
	selected_card_data=c.data
	if by_shortcut:
		range_node.check_tile_select()
	
func _on_card_unfocus(_c:CardUI):
	clear_range()

func _on_confirmed_at_rangelayer(posi:Vector2i):
	card_manager.clear_focus()
	print(posi)
	var pos = range_node.map_to_global(posi)
	for e in selected_card_data.effects:
		var r = e.create_request(player_node,{"target_pos":pos,"target_cell":posi})
		if AM:
			AM.request(r)
		else:
			push_error("no ActionManager in BattleManager")
	

func register_rangelayer(n:RangeLayer):
	range_node=n
	range_node.confirmed.connect(_on_confirmed_at_rangelayer)

func register_card_manager(m:CardManager):
	card_manager=m
	m.card_focus.connect(_on_card_focus)
	m.card_unfocus.connect(_on_card_unfocus)
