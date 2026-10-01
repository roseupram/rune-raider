extends CanvasLayer

#@export var main_menu:PackedScene
@export var seed_label:Label
@export var upper_layer:CanvasLayer
@export var card_flow:CardFlow
@export var card_manager:CardManager
@export var upper_label:Label

@onready var pile_buttons  = [$TopLayer/Discard,$TopLayer/Draw]

var disable_color = Color(.5,.5,.5)

var BM:BattleManager:
	set(bm):
		BM=bm
		BM.register_card_manager($Cards)
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	seed_label.text=SeedManager.encode_seed(SeedManager.main_seed)
	EventBus.stat_changed.connect(_on_stat_changed)
	
	upper_layer.hide()


func _on_stat_changed(from,to,source:Node):
	if source is CappedValue:
		$HpBar._on_changed(from,to,source.max_value)
	elif source is TurnValue:
		$EnegyBar._on_changed(from,to,source.base_value)
	#match source.type:
		#StatComponent.Type.HP:
			#n=$HpBar
		#StatComponent.Type.Enegy:
			#n=$EnegyBar
	#if n:
		#n._on_changed(from,to,source.max_value)
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

func show_cards(cards:Array[CardData]):
	card_flow.card_datas=cards
	card_flow.update_cards()
	upper_layer.show()

func set_control_anchor(control:Control,l,r,t,b):
	control.anchor_left=l
	control.anchor_right=r
	control.anchor_bottom=b
	control.anchor_top=t

func _on_draw_toggled(toggled_on: bool) -> void:
	if toggled_on:
		var cds = card_manager.draw_pile.duplicate()
		cds.sort_custom(CardData.sort_by_ID)
		show_cards(cds)
		$TopLayer/Discard.disabled=true
		upper_label.text="DRAW_UI"
	else:
		upper_layer.hide()
		$TopLayer/Discard.disabled=false
		

func _on_discard_toggled(toggled_on: bool) -> void:
	if toggled_on:
		show_cards(card_manager.discard_pile.duplicate())
		$TopLayer/Draw.disabled=true
		upper_label.text="DISCARD_UI"
		$TopLayer/DrawDotPanel.modulate=disable_color
	else:
		upper_layer.hide()
		$TopLayer/Draw.disabled=false
		$TopLayer/DrawDotPanel.modulate=Color.WHITE
		
		
