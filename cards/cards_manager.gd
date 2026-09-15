#@tool
extends Control
class_name CardManager

const CARD_UI = preload("uid://da51k3b2ha8i7")

var focused_card
signal card_focus(card:CardUI,by_shortcut:bool)
signal card_unfocus(leaved_card:CardUI)

@export var card_deck:Array[CardData]
@export var card_wh_ratio=1/1.3
@export var gap=10:
	set(g):
		gap=g
		arrange_cards.call_deferred()

# func _input(_event: InputEvent) -> void:
# 		if Input.is_action_just_pressed("cancel") and focused_card:
# 			clear_focus()
# 			get_viewport().set_input_as_handled()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c_data in card_deck:
		add_card(c_data)

	assign_shortcut()
	arrange_cards()
	resized.connect(_on_resize)

func add_card(data:CardData):
	if not data:
		push_error("CardData is "+str(data))
		return
	var card_ui:CardUI=CARD_UI.instantiate()
	card_ui.data=data
	card_ui.focus.connect(_on_card_focused)
	add_child(card_ui)

func assign_shortcut():
	var i=1
	for c:CardUI in get_children():
		c.shortcut_name="card_"+str(i)
		if not InputMap.has_action(c.shortcut_name):
			push_error("[%s] not exist in InputMap" % [c.shortcut_name])
		i+=1

func _on_resize():
	arrange_cards()

func _on_card_focused(card:CardUI,by_shortcut):
	clear_focus()
	focused_card=card
	card_focus.emit(focused_card,by_shortcut)
	#BattleManager.show_range(focused_card)
	#print(card.data)

func arrange_cards():
	var card_h = size.y
	var card_w = card_h*card_wh_ratio
	var n =get_child_count()
	var w = card_w* n + (n-1)*gap
	var start = size.x/2-w/2
	var step  = card_w+gap
	for i in range(n):
		var c:CardUI =get_child(i)
		c.position.x=start+step*i
		c.set_size.call_deferred(Vector2(card_w,card_h))

func discard():
	if focused_card:
		remove_child(focused_card)
		focused_card.queue_free()
		arrange_cards()
		assign_shortcut()
	else:
		push_error("no card to discard")
		
		
func clear_focus():
	if focused_card:
		focused_card.unfocus()
		#BattleManager.clear_range()
		focused_card=null
		card_unfocus.emit(focused_card)
		
