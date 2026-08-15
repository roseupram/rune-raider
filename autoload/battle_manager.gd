extends Node
class_name BattleManager

var range_node:RangeNode:
	set(n):
		range_node=n
		range_node.confirmed.connect(_on_confirmed)
		range_node.canceled.connect(_on_canceled)

var player_node:Player
var card_manager:CardManager
var selected_card_data:CardData
var AM:ActionManager

enum State{Idle,Wait_for_comfirm}

var current_state = State.Idle


func state_to(s):
	current_state=s

func show_range(card:CardUI):
	if not range_node:
		push_error("no range_node")
		return
	var d:CardData = card.data
	var color = Color(1,1,1,.5)
	var s_range = d.effects[0].scaled_range
	var r=DrawCircle.new(player_node.global_position, 
	s_range,4+log(2*s_range),color)
	range_node.request(r)
	r=DrawArrow.new(player_node.global_position,0,d.effects[0].scaled_range)
	range_node.request(r)
	state_to(State.Wait_for_comfirm)
	#var tile_mask=d.effects[0].tile_mask
	#var r=d.effects[0].range
	#var x_r = [-r,r+1]
	#var center:Vector2i  = range_node.global_to_map(player_node.global_position)
	#for i in range.callv(x_r):
		#for j in range.callv(x_r):
			#range_node.enable(center+Vector2i(i,j),tile_mask)
	#
func clear_range():
	card_manager.clear_focus()
	range_node.clear()
	state_to(State.Idle)

func _on_card_focus(c:CardUI,by_shortcut):
	show_range(c)
	selected_card_data=c.data
	print(c)
	#if by_shortcut:
		#range_node.check_tile_select()
	
func _on_card_unfocus(_c:CardUI):
	clear_range()

func _on_canceled():
	clear_range()

func _on_confirmed(pos):
	clear_range()
	print(pos)
	for e in selected_card_data.effects:
		var r = e.create_request(player_node,{"target_pos":pos})
		if AM:
			AM.request(r)
		else:
			push_error("no ActionManager in BattleManager")
	


func register_card_manager(m:CardManager):
	card_manager=m
	m.card_focus.connect(_on_card_focus)
	m.card_unfocus.connect(_on_card_unfocus)
