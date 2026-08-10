extends Node2D
class_name  Player

signal died

# glory kill to restore enegy and hp
# enegy like rescouce, may not be auto restored, 
# action-based (enemy moves when you use 2 move or 3 move)
# everything is a touchable item, like potion, it drops on ground, you can pick it, enemy also
# 

@onready var ham_node=$Base/Hitbox
@onready var Sprite = $Base
func heal(h):
	$Health.value+=h

func move_to(pos):
	var ani_time = .1
	var tw = get_tree().create_tween()
	#tw.set_ease(Tween.EASE_OUT_IN)
	tw.tween_property(self,"position",pos,ani_time)
	await tw.finished
	
func attack():
	var tween=get_tree().create_tween()
	
	ham_node.rotation = deg_to_rad(-90)
	Sprite.rotation = deg_to_rad(-60)
	
	ham_node.enable()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(Sprite,"rotation",0,0.2)
	tween.tween_property(ham_node,"rotation",deg_to_rad(120),.2)
	await  tween.finished
	ham_node.disable()
	ham_node.rotation=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ham_node.disable()

	$Health.changed.connect(_on_health_change)

func _on_health_change(_delta,current,_max_hp):
	if current<=0:
		died.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
