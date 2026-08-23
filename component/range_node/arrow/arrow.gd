extends Line2D

@export var normal_color=Color.CYAN
@export var warnning_color=Color.RED

@onready var head=$head
@onready var body=$Body

var is_warnning=false

var target


func draw_from_to(from:Vector2,to:Vector2):
	show()
	position=from
	target=to

func clear():
	target=null
	hide()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _physics_process(_delta: float) -> void:
	is_warnning=false
	if not target: return
	
	var d:Vector2 = target-position
	d= d.normalized()
	var head_size = head.texture.get_size()
	
	#var space = get_world_2d().space
	var state =get_world_2d().direct_space_state
	#var mask = 0b1010
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape=$Body/CollisionShape2D.shape
	query.collision_mask=body.collision_mask
	query.transform=Transform2D.IDENTITY.translated(position)
	query.motion=target-position-d*query.shape.radius
	var result = state.intersect_shape(query)
	var free_pos=target
	if result:
		#print(result)
		is_warnning=true
		#free_pos=result.position
	var dir = free_pos-position
	var end = Vector2(dir.length()-head_size.x,0)
	set_point_position(1,end)
	head.position=end
	rotation=d.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var c = normal_color
	if is_warnning:
		c  = warnning_color
	modulate=c
