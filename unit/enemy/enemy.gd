extends Unit
class_name Enemy
signal intention_get(intent:BattleManager.Intent)
signal action_finish()

@export_range(0.1,10.0) var move_gain = 10.0
@export var health_node:CappedValue
@export_range(1,10) var base_move:=2

var count=0

var player_enter=false
var other_enemy:Array[Node2D]=[]

enum  State{Idle,Move,Arrive,SIZE}
const intent_graph={
	State.Idle:{State.Move:1},
}
var current_state:=State.Idle

var one_step = 300
var accumulated_distance=0.0

@onready var dot_panel = $Control/dot_panel
@onready var anim_node = $AnimationPlayer
@onready var navi_agent = $NavigationAgent2D

func set_target(v:Vector2):
	navi_agent.target_position=v

func state_to(s:State):
	match s:
		State.Idle:
			#navi_agent.avoidance_priority=0.1
			navi_agent.velocity=Vector2.ZERO
			velocity=Vector2.ZERO
			action_finish.emit()
		State.Move:
			accumulated_distance=0.0
		State.Arrive:
			action_finish.emit()
			#arrived.emit()
			#velocity=Vector2.ZERO
			navi_agent.velocity=Vector2.ZERO
			#navi_agent.avoidance_priority=1
	current_state=s



func get_intention():
	var intent = BattleManager.Intent.MOVE_TO_PLAYER
	intention_get.emit(intent)

func _ready() -> void:
	#GameContext.card_played.connect(_on_action)
	count=base_move
	health_node.changed.connect(_on_health_change)
	EventBus.turn_end.connect(_on_turn_end)
	EventBus.enemy_spawn.emit.call_deferred(self)
	#EventBus.unit_moved.connect(_on_unit_move)
	#EventBus.turn_end.connect(_on_turn_end)

func act():
	match current_state:
		State.Idle:
			state_to(State.Move)
	
func _on_turn_end():
	get_intention()



func _on_health_change(from,to):
	if to <=0:
		died()

func died():
	EventBus.enemy_died.emit(self)
	anim_node.play("die")
	await  anim_node.animation_finished
	queue_free()


func update_move():
	dot_panel.number=count

func take_damage(d):
	anim_node.play("hurt")
	health_node.value-=d


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


func _physics_process(delta: float) -> void:
	#if navi_agent.is_navigation_finished(): 
		#state_to(State.Idle)
		
	match  current_state:
		State.Move:
			accumulated_distance+=delta*velocity.length()
			if accumulated_distance >= one_step : 
				state_to(State.Idle)
				return
			var from = global_position
			var to = navi_agent.get_next_path_position()
			var dir = to-from
			var new_v:Vector2 = dir*move_gain
			navi_agent.velocity+=new_v
			



func _draw() -> void:
	draw_line(Vector2.ZERO,velocity,Color.BLACK,5)

func _process(_delta: float) -> void:
	if get_tree().debug_collisions_hint:
		queue_redraw()
		modulate= Color.RED if player_enter else Color.WHITE



func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		player_enter=true
		state_to(State.Arrive)



func _on_hitbox_body_exited(body: Node2D) -> void:
	if body is Player:
		player_enter=false
		accumulated_distance=one_step+1
		state_to(State.Idle)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			print(self,"right clicked")


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity=safe_velocity
	move_and_slide()

	


func _on_other_detector_body_entered(body: Node2D) -> void:
	if body!=self:
		other_enemy.push_back(body)


func _on_other_detector_body_exited(body: Node2D) -> void:
	if body!=self:
		other_enemy.erase(body)
