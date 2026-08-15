extends Node
# main game


@export var Map:BaseTileMap
@export var rangelayer:RangeLayer
@export var ui_layer:CanvasLayer

var AM := ActionManager.new()
var BM := BattleManager.new()
var NM:=NavManager.new()

func _ready() -> void:
	rangelayer.clear()
	Map.AM=AM
	BM.AM=AM
	ui_layer.BM=BM
	
	NM.overwrite_by_map(Map)
	
	for i in [$Player,$Unit,$Unit2]:
		i.global_position = $Map.snap_to_global(i.global_position)
	for i in [$Unit,$Unit2]:
		NM.set_occupied(i.global_position)

	Map.set_id($Player.global_position,BaseTileMap.Type.Player)
	BM.player_node=$Player
	BM.register_rangelayer($RangeLayer)
		
	var tile_size =Vector2( Map.tile_set.tile_size)
	var map_left_top= Map.left_top()
	var map_right_bottom=Map.right_bottom()
	var screen_size = get_viewport().get_visible_rect().size

	$Camera.limit_top=(map_left_top-tile_size).y
	$Camera.limit_bottom=(map_right_bottom+tile_size).y-screen_size.y
	


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

	
	
	
