extends Node
# main game


@onready var Map:BaseTileMap = $Map

var AM = ActionManager.new()
var BM = BattleManager.new()
var NM=NavManager.new()

func _ready() -> void:
	$RangeLayer.clear()
	Map.AM=AM
	BM.AM=AM
	$GameplayUI.BM=BM
	
	var player_hp = $Player/Health
	var player_ma = $Player/Mana
	#var hpbar = $UI/GameplayUI/HpBar
	#hpbar.stat_node=player_hp
	#var mabar= $UI/GameplayUI/ManaBar
	#mabar.stat_node=player_ma
	
	
	NM.overwrite_by_map($Map)
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

#func _process(delta: float) -> void:
	#var pos_y = $Camera.position.y 

	
	
	
