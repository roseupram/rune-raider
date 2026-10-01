#@tool
extends Control
class_name CardManager

const CARD_UI = preload("uid://da51k3b2ha8i7")

var focused_card
signal card_focus(card:CardHandUI,by_shortcut:bool)
signal card_unfocus(leaved_card:CardHandUI)

@export var card_deck:Array[CardData]
@export var card_wh_ratio=1/1.3
@export var gap=10:
	set(g):
		gap=g
		arrange_cards.call_deferred()

var draw_pile:Array[CardData]=[]
var discard_pile:Array[CardData]=[]

var current_enegy=0
# var hand_pile:Array[CardData]=[]


# func _input(_event: InputEvent) -> void:
# 		if Input.is_action_just_pressed("cancel") and focused_card:
# 			clear_focus()
# 			get_viewport().set_input_as_handled()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.turn_end.connect(_on_turn_end)
	EventBus.turn_start.connect(_on_turn_start)
	EventBus.stat_changed.connect(_on_stat_change)
	resized.connect(_on_resize)

	for d in card_deck:
		draw_pile.push_back(d)
	shuffle(draw_pile)

func _on_stat_change(from,to,node):
	if node.is_in_group("Enegy"):
		current_enegy=to

func _on_turn_start():
	draw_card(5)

func _on_turn_end():
	for c:CardHandUI in get_children():
		discard_pile.append(c.data)
		c.queue_free()

# shuffle draw_pile
func shuffle(pile):
	var rng=SeedManager.get_RNG("shuffle")
	for i in range(pile.size()-1,0,-1):
		var j  = rng.randi_range(0,i)
		#swap
		var t=pile[j]
		pile[j]=pile[i]
		pile[i]=t

func draw_card(n=1):
	for i in range(n):
		if draw_pile.size()==0:
			draw_pile=discard_pile
			discard_pile=[]
			shuffle(draw_pile)
		add_card(draw_pile.pop_back())
	arrange_cards()

func add_card(data:CardData):
	if not data:
		push_error("CardData is "+str(data))
		return
	var card_ui:CardHandUI=CARD_UI.instantiate()
	var disc_fn  = func(): 
		discard_pile.append(data)
		card_ui.queue_free()
		remove_child(card_ui)
		arrange_cards()
	var e_fn=func ():return current_enegy
	card_ui.discard=disc_fn
	card_ui.get_enegy=e_fn
	card_ui.data=data
	card_ui.focus.connect(_on_card_focused)
	add_child(card_ui)

func assign_shortcut():
	var i=1
	for c:CardHandUI in get_children():
		c.shortcut_name="card_"+str(i)
		if not InputMap.has_action(c.shortcut_name):
			push_error("[%s] not exist in InputMap" % [c.shortcut_name])
		i+=1

func _on_resize():
	arrange_cards()

func _on_card_focused(card:CardHandUI,by_shortcut):
	clear_focus()
	focused_card=card
	card_focus.emit(focused_card,by_shortcut)
	#BattleManager.show_range(focused_card)
	#print(card.data)

func arrange_cards():
	assign_shortcut()
	var card_h = size.y
	var card_w = card_h*card_wh_ratio
	var n =get_child_count()
	var w = card_w* n + (n-1)*gap
	var start = size.x/2-w/2
	var step  = card_w+gap
	for i in range(n):
		var c:CardHandUI =get_child(i)
		var x=start+step*i
		c.move_to(Vector2(x,c.position.y))
		c.set_size.call_deferred(Vector2(card_w,card_h))

func discard(card=null):
	if card==null and focused_card:
		remove_child(focused_card)
		focused_card.queue_free()
		arrange_cards()
	else:
		push_error("no card to discard")
		
		
func clear_focus():
	if focused_card:
		focused_card.unfocus()
		#BattleManager.clear_range()
		focused_card=null
		card_unfocus.emit(focused_card)
		
