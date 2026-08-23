extends Unit

var count=0
@export_range(1,10) var base_move:=2
var move_ablitity=1
var player_enter=false
var hit_target

enum  State{Move,Attack,Died}
var accumulated_distance=0.0
var one_step = 200
var state=State.Move
var player_pos
@export var speed = 200
@export var health_node:StatComponent
@onready var dot_panel = $Control/dot_panel
@onready var anim_node = $AnimationPlayer
@onready var navi_agent = $NavigationAgent2D

func _on_turn_end():
	navi_agent.avoidance_enabled=true
	navi_agent.target_position=player_pos
	accumulated_distance=0.0
	

func _on_unit_move(from,to,unit):
	if unit is Player:
		player_pos=to


func _ready() -> void:
	#GameContext.card_played.connect(_on_action)
	count=base_move
	health_node.changed.connect(_on_health_change)
	update_move()
	EventBus.unit_moved.connect(_on_unit_move)
	EventBus.turn_end.connect(_on_turn_end)

func died():
	anim_node.play("die")
	await  anim_node.animation_finished
	queue_free()

func _on_health_change(from,to):
	if to <=0:
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
		

func _physics_process(delta: float) -> void:
	if navi_agent.is_navigation_finished(): return
	accumulated_distance+=delta*velocity.length()
	#print("accumu_distance %f" % accumulated_distance)
	if accumulated_distance > one_step or player_enter: 
		stop()
		return
	var from = global_position
	var to = navi_agent.get_next_path_position()
	
	var new_v = from.direction_to(to)*speed
	navi_agent.velocity=new_v
	#print(velocity,from,to)
	#move_and_slide()

func _process(_delta: float) -> void:
	if player_enter:
		modulate=Color.RED
		pass
	else :
		modulate=Color.WHITE

func stop():
	navi_agent.velocity=Vector2.ZERO
	#navi_agent.target_position=global_position
	#navi_agent.avoidance_enabled=false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		player_enter=true
		hit_target=body
	


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body is Player:
		player_enter=false
		hit_target=null


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			print(self,"right clicked")


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity=safe_velocity
	move_and_slide()
