extends Node2D

var count=0
@export var base_move=2
var move_ablitity=1
var player_enter=false
var hit_target

enum  State{Move,Attack,Died}
var state=State.Move

@onready var dot_panel = $Control/dot_panel
@onready var health_node = $Health
@onready var anim_node = $AnimationPlayer


func _ready() -> void:
	#GameContext.card_played.connect(_on_action)
	count=base_move
	health_node.changed.connect(_on_health_change)
	update_move()

func died():
	anim_node.play("die")
	await  anim_node.animation_finished
	queue_free()

func _on_health_change(delta,current,max_hp):
	if current<=0:
		died()

func update_move():
	dot_panel.number=count

func take_damage(d):
	anim_node.play("hurt")
	health_node.value-=d

func move_to(pos):
	pass
	#var navi = GameContext.Navi
	#var map = GameContext.Map
	#GameContext.set_navi_solid(position,false)
	#navi.set_point_solid(map.global_to_map(pos),true)
	#map.set_id(position,BaseTileMap.Type.Free)
	#if position.x!=pos.x:
		#var face_right=pos.x>position.x
		#$AnimatedSprite2D.flip_h=face_right
	#var tween = get_tree().create_tween()
	#tween.tween_property(self,"position",pos,.1)
	#await tween.finished
	#
	#map.set_id(pos,BaseTileMap.Type.Occupied)
	

#func move_to_player():
	#var player_pos=GameContext.Player.position
	#var path = GameContext.find_path(position,player_pos)
	#var pos=position
	#var Map = GameContext.Map
	#if path :
		#var index_max = path.size()-2
		#var index_next = clamp(move_ablitity,0,index_max)
		#pos=Map.to_global(path[index_next])
		#move_to(pos)

#func attack_player():
	#var player_pos = GameContext.Player.position
	#var old_z = z_index
	#z_index=100
	#var tw = get_tree().create_tween()
	#var hit_pos = player_pos*.7+position*0.3
	#tw.tween_property(self,"position",hit_pos,.1)
	#tw.parallel().tween_property(self,"scale",Vector2(1,1)*1.2,.07)
	#tw.tween_property(self,"scale",Vector2(1,1),.03)
	#tw.tween_property(self,"position",position,.1)
	#await  tw.finished
	#z_index=old_z
	#var player_hp = hit_target.get_node("Health")
	#player_hp.value-=6
#
#func _on_action(_card):
	#count-=1
	#update_move()
	#if count==0:
		#var player_pos = GameContext.Player.position
		#var player_celli = GameContext.Map.global_to_map(player_pos)
		#var celli = GameContext.Map.global_to_map(position)
		#var diff = player_celli-celli
		#diff = diff.abs()
		#if max(diff.x,diff.y)==1:
			#player_enter=true
		#else:
			#player_enter=false
	#
		#if player_enter:
			#attack_player()
		#else:
			#move_to_player()
		#count=base_move
		#update_move()
		


func _process(delta: float) -> void:
	if player_enter:
		#modulate=Color.RED
		pass
	else :
		modulate=Color.WHITE


func _on_hitbox_area_entered(area: Area2D) -> void:
	player_enter=true
	hit_target=area
	


func _on_hitbox_area_exited(area: Area2D) -> void:
	player_enter=false
	hit_target=null


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			print("clicked")
