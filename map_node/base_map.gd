extends TileMapLayer
class_name BaseTileMap

var AM:ActionManager:
	set(am):
		AM=am
		AM.action_completed.connect(_on_action_completed)

enum Type {
	Free=1 << 0, 	# 1 
	Enemy=1 << 1, #2 
	Player=1<<2, #4
	Obstacle=1<<3 #8
}
@onready var tile_size_i = tile_set.tile_size

func left_top():
	var recti=get_used_rect()
	return to_global(recti.position*tile_size_i)
	
func right_bottom():
	var recti=get_used_rect()
	return to_global(recti.end*tile_size_i)
	

func isfree(pos):
	var id = get_cell_source_id(check_v2i(pos))
	return id==Type.Free
		

func get_id(pos):
	var id = get_cell_source_id(check_v2i(pos))
	return id


func set_id(pos,id=Type.Free):
	set_cell(check_v2i(pos),id,Vector2i(0,0))

func check_v2i(pos):
	if pos is Vector2:
		pos = global_to_map(pos)
	return pos

func isvalid(pos):
	return get_cell_tile_data(check_v2i(pos))

func global_to_map(pos:Vector2) -> Vector2i:
	return local_to_map(to_local(pos))

func map_to_global(posi: Vector2i):
	return to_global(map_to_local(posi))

func snap_to_global(pos: Vector2):
	pos = map_to_global(global_to_map(pos))
	return pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if AM==null:
		push_error("No ActionManager in BaseTileMap")

func _on_action_completed(a:ActionRequest):
	if a is MoveRequest and a.actor is Player:
		var from = global_to_map(a.from)
		var to = global_to_map(a.target_position)
		set_id(from,Type.Free)
		set_id(to,Type.Player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
