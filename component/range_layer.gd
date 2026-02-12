extends BaseTileMap

func enable(v,y=0):
	if v is Vector2i:
		set_cell(v,1,Vector2i(0,0))
	elif v is int:
		enable(Vector2i(v,y)) 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
