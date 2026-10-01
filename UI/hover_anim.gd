extends Node
class_name  HoverAnim

@export var node:Control
@export_custom(PROPERTY_HINT_LINK,"") var hover_scale = Vector2(1.2,1.2)
var anim_scale 
var normal_scale
@export var tween_time = 0.1
var tw:Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	node.mouse_entered.connect(_on_mouse_enter)
	node.mouse_exited.connect(_on_mouse_exit)
	normal_scale=node.scale
	anim_scale=hover_scale*normal_scale

func _on_mouse_enter():
	if tw: tw.kill()
	tw = create_tween()
	tw.tween_property(node,"scale",anim_scale,tween_time)
func _on_mouse_exit():
	if tw: tw.kill()
	tw = create_tween()
	tw.tween_property(node,"scale",normal_scale,tween_time)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
