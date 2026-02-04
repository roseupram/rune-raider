extends Camera2D

var target_pos=Vector2()
@export_range(1,10) var speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var limit_min=Vector2(limit_left,limit_top)
	var limit_max = Vector2(limit_right,limit_bottom)
	target_pos = target_pos.clamp(limit_min,limit_max)
	position.y =lerp(position.y,target_pos.y,speed*delta)

func move_step(step):
	target_pos+=step
