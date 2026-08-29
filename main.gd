extends Node
# main game

@export var ui_layer:CanvasLayer
@export var BM:BattleManager

var AM := ActionManager.new()
var NM:=NavManager.new()

func _ready() -> void:
	BM.AM=AM
	BM.range_node=$RangeNode
	BM.player_node=$Player
	
	$Player.move_to($Player.global_position)
	
	ui_layer.BM=BM

func _process(delta: float) -> void:
	AM.act()
	#var pos_y = $Camera.position.y 

	
	
	
