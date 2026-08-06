extends HBoxContainer

var focused_card

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_RIGHT and event.pressed and focused_card:
			focused_card.unfocus()
			focused_card=null
			get_viewport().set_input_as_handled()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in get_children():
		c.focus.connect(_on_card_focused.bind(c))

func _on_card_focused(card):
	if focused_card:
		focused_card.unfocus()
	focused_card=card

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
