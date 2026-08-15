extends Node
# main game



@export var ui_layer:CanvasLayer
@export var BM:BattleManager

var AM := ActionManager.new()
var NM:=NavManager.new()

func _ready() -> void:
	BM.AM=AM
	BM.range_node=$RangeNode
	ui_layer.BM=BM
	BM.player_node=$Player
		

	var screen_size = get_viewport().get_visible_rect().size

	


func _unhandled_input(event: InputEvent) -> void:
	#Camera_move_dir=Vector2.ZERO
	if event.is_action_released("click"):
		pass
	# 	var pos = get_viewport().get_mouse_position()
	# 	print(pos)
	# 	pos=$Camera.to_global(pos)
	# 	if $RangeLayer.isvalid(pos) and select_card:
	# 		$RangeLayer.clear()

func _process(delta: float) -> void:
	AM.act()
	var pos_y = $Camera.position.y 

	
	
	
