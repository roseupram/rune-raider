extends CanvasLayer

#@export var main_menu:PackedScene

var BM:BattleManager:
	set(bm):
		BM=bm
		BM.register_card_manager($Cards)
# Called when the node enters the scene tree for the first time.

func _ready() -> void:

	EventBus.stat_changed.connect(_on_stat_changed)


func _on_stat_changed(from,to,source:StatComponent):
	var n
	match source.type:
		StatComponent.Type.HP:
			n=$HpBar
		StatComponent.Type.Enegy:
			n=$EnegyBar
	if n:
		n._on_changed(from,to,source.max_value)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_option_button_item_selected(index: int) -> void:
	var text = $OptionButton.get_item_text(index)
	#print(text)
	TranslationServer.set_locale(text)
	for child in $Cards.get_children():
		child._update_data()
	


func _on_end_button_button_up() -> void:
	#print("button up")
	EventBus.turn_end.emit()


func _on_backto_menu_pressed() -> void:
	EventBus.to_menu()
