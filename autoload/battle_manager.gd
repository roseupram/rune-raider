extends Node
class_name BattleManager
## receive intention, on turn end, execute all intention
enum Intent{MOVE,MOVE_TO_PLAYER}


var range_node:RangeNode:
	set(n):
		range_node=n
		range_node.confirmed.connect(_on_confirmed)
		range_node.canceled.connect(_on_canceled)

var player_node:Player
var card_manager:CardManager
var selected_card:CardHandUI
var AM:ActionManager

enum State{Idle,Wait_for_comfirm}
var current_state = State.Idle

var position_assign_array=[]
var intent_count = 0
var finish_count = 0
var enemy_count = 0

func _ready() -> void:
	EventBus.turn_end.connect(_on_turn_end,ConnectFlags.CONNECT_DEFERRED)
	EventBus.enemy_spawn.connect(_on_enemy_spawn)
	EventBus.enemy_died.connect(_on_enemy_died)
	EventBus.turn_start.emit()

func _on_enemy_died(e):
	enemy_count-=1

# FIXME if enemy died, remove from array
func _on_turn_end():
	intent_count=0
	finish_count=0
	for e:Node in position_assign_array:
		if e.has_method("act"):
			e.act()
	position_assign_array.clear()

func _on_enemy_spawn(e:Enemy):
	enemy_count+=1
	# print("enemy %d" % enemy_count)
	e.intention_get.connect(_receive_intention.bind(e))
	e.action_finish.connect(_on_enemy_action_finish)

func _on_enemy_action_finish():
	finish_count+=1
	print("BM finish count{0}/{1}".format([finish_count,enemy_count]))
	if finish_count==enemy_count:
		EventBus.turn_start.emit()


func _receive_intention(intent:Intent,node:Node):
	match  intent:
		Intent.MOVE_TO_PLAYER:
			var method_name="set_target"
			if node.has_method(method_name):
				# node[method_name].call(player_node.global_position)
				position_assign_array.push_back(node)
	intent_count+=1
	if intent_count==enemy_count:
		assign_target_pos(position_assign_array)
		# print("assign position")

func assign_target_pos(nodes:Array):
	# TODO need sort by angle
	var center = player_node.global_position
	var n_parts = 6
	var last_angle
	var gap  = TAU/n_parts
	var u=Vector2(140,0)
	for n in nodes:
		var dir = n.global_position - center
		var pos = center
		var angle = dir.angle()
		if last_angle and abs(last_angle-angle)<gap:
			angle=last_angle+gap
		pos+=u.rotated(angle)
		last_angle=angle
		n.set_target(pos)

func state_to(s):
	current_state=s

func show_range(card:CardHandUI):
	if not range_node:
		push_error("no range_node")
		return
	var d:CardData = card.data
	var color = Color(0.0, 1.0, 1.0, 0.802)
	var s_range = d.effects[0].scaled_range
	var r=DrawCircle.new(player_node.global_position, 
	s_range,2+log(0.5*s_range),color)
	range_node.request(r)
	r=DrawArrow.new(player_node.global_position,0,d.effects[0].scaled_range)
	range_node.request(r)
	state_to(State.Wait_for_comfirm)

func clear_range():
	card_manager.clear_focus()
	range_node.clear()
	state_to(State.Idle)

func _on_card_focus(c:CardHandUI,_by_shortcut):
	show_range(c)
	selected_card=c
	# print(c)
	#if by_shortcut:
		#range_node.check_tile_select()
	
func _on_card_unfocus(_c:CardHandUI):
	clear_range()

func _on_canceled():
	clear_range()

func _on_confirmed(pos):
	selected_card.played()
	clear_range()
	var current_enegy = player_node.enegy()
	var card_data = selected_card.data
	player_node.enegy(current_enegy-card_data.cost)
	for e in card_data.effects:
		var r = e.create_request(player_node,{"target_pos":pos})
		if AM:
			AM.request(r)
		else:
			push_error("no ActionManager in BattleManager")
	


func register_card_manager(m:CardManager):
	card_manager=m
	m.card_focus.connect(_on_card_focus)
	m.card_unfocus.connect(_on_card_unfocus)
