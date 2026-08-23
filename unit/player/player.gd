extends Unit
class_name  Player

signal died

# glory kill to restore enegy and hp
# enegy like rescouce, may not be auto restored, 
# action-based (enemy moves when you use 2 move or 3 move)
# everything is a touchable item, like potion, it drops on ground, you can pick it, enemy also
# 

@export var move_gain=12

@export var hp_node:StatComponent
@onready var ham_node=$Base/Hitbox
@onready var Sprite = $Base
@onready var skeleton = $Base/Hamman
func heal(h):
	hp_node.value+=h

func move_to(pos):
	var from = global_position
	var d:Vector2 =pos-global_position
	var distance = d.length()
	var flip = d.sign().x
	var no_collide=true
	if flip!=0:
		scale=Vector2(flip,1)
		rotation=0
	#print("dir: {0}, scale: {1}".format([d,scale]))

	skeleton.blur(d)
	while distance>10 and no_collide:
		velocity=d.normalized()*move_gain*distance
		move_and_slide()
		distance=global_position.distance_to(pos)
		var c = get_last_slide_collision()
		if c:
			no_collide=false
		await  get_tree().physics_frame
	skeleton.deblur()
	
	EventBus.unit_moved.emit(from, global_position,self)
	#var ani_time = clamp(.05*d.length()/128,.1,.2)
	#var tw = get_tree().create_tween()
	##tw.set_ease(Tween.EASE_OUT_IN)
	#tw.tween_property(self,"position",pos,ani_time)
	#await tw.finished
	
func attack(target_pos:Vector2):
	var d = target_pos-global_position
	var rotate_deg = rad_to_deg(d.angle())
	# print(rotate_deg)
	var scx = 1
	if rotate_deg>-90 and rotate_deg<91:
		rotate_deg=rotate_deg+45
	else:
		rotate_deg=-rotate_deg-135
		scx=-1
	scale=Vector2(scx,1)
	rotation=0
	$Marker2D/RemoteTransform2D.rotation=deg_to_rad(rotate_deg)
	$AnimationPlayer.play("swing")
	await  $AnimationPlayer.animation_finished
	$Marker2D/RemoteTransform2D.rotation=0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ham_node.disable()
	hp_node.changed.connect(_on_health_change)

func _on_health_change(from,to):
	EventBus.stat_changed.emit(from,to,$Health)
	if to<=0:
		died.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
