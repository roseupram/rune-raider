
extends Node2D
class_name RangeNode
# Type: direction, one target, area

#TODO combine to one, finish(success:bool) or one request class
signal confirmed(pos) # pos or target
signal canceled

enum  S{Idle,Wait_for_comfirm}
var current_state=S.Idle

var draw_requests:Array[DrawRequest]=[]

@onready var arrow_node = $Arrow

var center=Vector2.ZERO
var max_range=0.0

func request(r):
	draw_requests.push_back(r)
	current_state=S.Wait_for_comfirm
	show()

func clear():
	hide()
	draw_requests.clear()
	arrow_node.clear()
	current_state=S.Idle
	
func _unhandled_input(_event: InputEvent) -> void:
	if current_state==S.Wait_for_comfirm:
		queue_redraw()
		var handled=true
		if Input.is_action_just_released("confirm"):
			var player = center
			var dir = get_global_mouse_position()-player
			dir = dir.normalized()*clamp(dir.length(),0,max_range)
			confirmed.emit(dir+player)
		elif Input.is_action_just_pressed("cancel"):
			canceled.emit()
			clear()
		else:
			handled=false
		if handled:
			get_viewport().set_input_as_handled()
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#queue_redraw()
	clear()
	pass # Replace with function body.
func _draw() -> void:
	for r in draw_requests:
		r.draw(self)

func draw_arrow(start,max_range_):
	arrow_node.show()
	var dir:Vector2 = get_global_mouse_position()-start
	var vec =dir.normalized()*clamp(dir.length(),0,max_range_)
	arrow_node.draw_from_to(start,start+vec)
	center = start
	max_range=max_range_
