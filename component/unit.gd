extends Area2D

var count=0
var base_move=2
@onready var dot_panel = $Control/dot_panel
func _ready() -> void:
	GameContext.card_played.connect(_on_action)
	count=base_move
	update_move()
	
func update_move():
	dot_panel.number=count
	
func move_to(pos):
	var navi = GameContext.Navi
	var map = GameContext.Map
	GameContext.set_navi_solid(position,false)
	navi.set_point_solid(map.global_to_map(pos),true)
	if position.x!=pos.x:
		var face_right=pos.x>position.x
		$AnimatedSprite2D.flip_h=face_right
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",pos,.1)
	await tween.finished
	
	
func _on_action(_card):
	count-=1
	if count==0:
		var player_pos=GameContext.Player.position
		var celli = GameContext.Map.global_to_map(position)
		var navi = GameContext.Navi
		var path = GameContext.find_path(position,player_pos)
		celli.x-=1
		var pos=position
		var Map = GameContext.Map
		if path :
			var index_max = path.size()-2
			var index_next = clamp(1,0,index_max)
			pos=Map.to_global(path[index_next])
			move_to(pos)
		count=base_move
	update_move()
		
