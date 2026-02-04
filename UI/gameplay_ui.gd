extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ci =1
	for button:Button in $Cards.get_children():
		button.pressed.connect(_on_button.bind(button))
		var action=InputEventAction.new()
		action.action="card_%d" % ci
		button.shortcut.events.clear()
		button.shortcut.events.push_back(action)
		ci+=1
	var all_locales = TranslationServer.get_loaded_locales()
	var current_locale = TranslationServer.get_locale()
	var current_locale_id = 0
	var i =0 
	$OptionButton.clear()
	for locale in all_locales:
		if locale==current_locale:
			current_locale_id=i
		$OptionButton.add_item(locale)
		i+=1
	$OptionButton.select(current_locale_id)
	
func _on_button(card):
	GameContext.card_selected.emit(card.data)
	#print(card.data.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_option_button_item_selected(index: int) -> void:
	var text = $OptionButton.get_item_text(index)
	#print(text)
	TranslationServer.set_locale(text)
	for child in $Cards.get_children():
		child._update_data()
	
