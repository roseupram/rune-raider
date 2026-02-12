extends Area2D

var count=0
var base_move=2
@onready var text_node = $Control/Panel/Label
func _ready() -> void:
	GameContext.card_played.connect(_on_action)
	count=base_move
	update_move()
	
func update_move():
	text_node.text=str(count)
	
func _on_action(card):
	count-=1
	if count==0:
		var player_pos=GameContext.Player.position
		var path = GameContext.find_path(position,player_pos)
		print(path)
		var celli = GameContext.Map.global_to_map(position)
		celli.x-=1
		var pos=position
		var Map = GameContext.Map
		if path and Map.global_to_map(path[1])!=Map.global_to_map(player_pos):
			pos=Map.to_global(path[1])
			if position.x!=pos.x:
				var face_right=pos.x>position.x
				$AnimatedSprite2D.flip_h=face_right
		count=base_move
		update_move()
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position",pos,.1)
		await tween.finished
	update_move()
		
