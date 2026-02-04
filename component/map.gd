extends TileMapLayer
class_name MyTileMap

func isvalid(pos):
	if pos is Vector2:
		pos = global_to_map(pos)
	return get_cell_tile_data(pos)

func global_to_map(pos:Vector2):
	return local_to_map(to_local(pos))

func map_to_global(posi: Vector2i):
	return to_global(map_to_local(posi))

func snap_to_global(pos: Vector2):
	pos = map_to_local(global_to_map(pos))
	pos = to_global(pos)
	return pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
