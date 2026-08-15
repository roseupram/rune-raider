
extends Node2D
class_name RangeNode

signal confirmed(pos)
signal canceled

enum  S{Idle,Wait_for_comfirm}
var current_state=S.Idle

var draw_requests:Array[DrawRequest]=[]
@onready var line_node = $Line2D
@onready var arrow_head=$Line2D/Sprite2D
@onready var raycast=$RayCast2D

var center=Vector2.ZERO
var max_range=0.0
var collide_pos:Vector2

func request(r):
	draw_requests.push_back(r)
	current_state=S.Wait_for_comfirm
	show()

func clear():
	hide()
	draw_requests.clear()
	line_node.hide()
	current_state=S.Idle
	
func _input(_event: InputEvent) -> void:
	if current_state==S.Wait_for_comfirm:
		queue_redraw()
		var handled=true
		if Input.is_action_just_released("confirm"):
			var player = center
			var dir = collide_pos-player
			dir = dir.normalized()*clamp(dir.length(),0,max_range)
			confirmed.emit(dir+player)
		elif Input.is_action_just_pressed("cancel"):
			canceled.emit()

		else:
			handled=false
		if handled:
			get_viewport().set_input_as_handled()
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
	pass # Replace with function body.
func _draw() -> void:
	for r in draw_requests:
		draw_r(r)

func draw_r(r:DrawRequest):
	if 	r is DrawCircle:
		var points = 32
		draw_arc(r.center,r.radius,0,TAU,points,r.color,r.line_width,true)
		center = r.center
		max_range=r.radius
	elif r is DrawArrow:
		draw_arrow(r)

func draw_arrow(r):
	line_node.show()
	#var mouse=get_global_mouse_position()
	var dir:Vector2 = collide_pos-r.start
	line_node.position=r.start
	var t_size = arrow_head.texture.get_size()
	var end =Vector2(clamp(dir.length(),r.min_l,r.max_l)-t_size.x,0)
	line_node.set_point_position(1,end)
	arrow_head.position=end
	line_node.rotation=dir.angle()

	center = r.start
	max_range=r.max_l

func _process(delta: float) -> void:
	collide_pos=get_global_mouse_position()
	raycast.position=center
	raycast.target_position=raycast.to_local(collide_pos)
	if raycast.is_colliding():
		collide_pos=raycast.get_collision_point()
