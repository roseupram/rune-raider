extends Control

var focused_card

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_RIGHT and event.pressed and focused_card:
			clear_focus()
			get_viewport().set_input_as_handled()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var height = size.y
	var child_size  = Vector2(height,height)
	var i=1
	for c:CardUI in get_children():
		c.focus.connect(_on_card_focused)
		c.size=child_size
		c.shortcuts=InputMap.action_get_events("card_"+str(i))
		i+=1

func _on_card_focused(card:CardUI):
	clear_focus()
	focused_card=card
	BattleManager.show_range(focused_card)
	#print(card.data)

func clear_focus():
	if focused_card:
		focused_card.unfocus()
		BattleManager.clear_range()
		focused_card=null
		
