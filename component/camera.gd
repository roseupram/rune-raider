extends Camera2D
# move wheel to up and down
# maybe use edge move

@export var MoveStep=100

var target_pos=Vector2()
@export_range(1,10) var speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var cam_move=Vector2.ZERO
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			cam_move.y-=1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			cam_move.y+=1
		move_by(cam_move*MoveStep)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var limit_min=Vector2(limit_left,limit_top)
	var limit_max = Vector2(limit_right,limit_bottom)
	target_pos = target_pos.clamp(limit_min,limit_max)
	position.y =lerp(position.y,target_pos.y,speed*delta)

func move_by(step):
	target_pos+=step
