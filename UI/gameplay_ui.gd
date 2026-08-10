extends CanvasLayer

var BM:BattleManager:
	set(bm):
		BM=bm
		BM.register_card_manager($Cards)
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
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



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_option_button_item_selected(index: int) -> void:
	var text = $OptionButton.get_item_text(index)
	#print(text)
	TranslationServer.set_locale(text)
	for child in $Cards.get_children():
		child._update_data()
	
