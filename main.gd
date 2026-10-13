extends Node
# main game

@export var ui_layer:CanvasLayer
@export var BM:BattleManager

@onready var player:Player = $Player

var AM := ActionManager.new()
var NM:=NavManager.new()

func _ready() -> void:
	BM.AM=AM
	BM.range_node=$RangeNode
	BM.player_node=player
	
	player.move_to($Player.global_position)

	player.died.connect(_on_player_died)
	
	ui_layer.BM=BM

func _process(delta: float) -> void:
	AM.act()
	#var pos_y = $Camera.position.y 

func _on_player_died():
	pass
	SceneManager.to_menu.call_deferred()

	
	
	
