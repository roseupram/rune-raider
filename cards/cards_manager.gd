@tool
extends Control
class_name CardManager

var focused_card
signal card_focus(card:CardUI,by_shortcut:bool)
signal card_unfocus(leaved_card:CardUI)
@export var gap=10:
	set(g):
		gap=g
		arrange_cards()

# func _input(_event: InputEvent) -> void:
# 		if Input.is_action_just_pressed("cancel") and focused_card:
# 			clear_focus()
# 			get_viewport().set_input_as_handled()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var height = size.y
	var child_size  = Vector2(height,height)
	var i=1
	for c:CardUI in get_children():
		c.focus.connect(_on_card_focused)
		c.set_deferred("size",child_size)
		c.shortcut_name="card_"+str(i)
		if not InputMap.has_action(c.shortcut_name):
			push_error("[%s] not exist in InputMap" % [c.shortcut_name])
		i+=1
	arrange_cards()
	resized.connect(_on_resize)

func _on_resize():
	arrange_cards()

func _on_card_focused(card:CardUI,by_shortcut):
	clear_focus()
	focused_card=card
	card_focus.emit(focused_card,by_shortcut)
	#BattleManager.show_range(focused_card)
	#print(card.data)

func arrange_cards():
	var card_w = size.y
	var n =get_child_count()
	var w = card_w* n + (n-1)*gap
	var start = size.x/2-w/2
	var step  = card_w+gap
	for i in range(n):
		var c:CardUI =get_child(i)
		c.position.x=start+step*i
		c.size = Vector2(card_w,card_w)

func clear_focus():
	if focused_card:
		focused_card.unfocus()
		#BattleManager.clear_range()
		focused_card=null
		card_unfocus.emit(focused_card)
		
		
