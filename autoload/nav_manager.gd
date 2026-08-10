extends RefCounted
class_name NavManager

var Navi=AStarGrid2D.new()

func _ready() -> void:
	pass
	# randomize()

func find_path(start,end):
	start=check_v2i(start)
	end=check_v2i(end)

	var path = Navi.get_point_path(start,end)
	return path


func set_free(pos):
	Navi.set_point_solid(check_v2i(pos),false)

func set_occupied(pos):
	Navi.set_point_solid(check_v2i(pos),true)

func check_v2i(pos):
	if pos is Vector2:
		pos=to_ceil(pos)
	return pos

func to_ceil(pos:Vector2) -> Vector2i:
	var posi = Vector2i(pos)/Vector2i(Navi.cell_size)
	return posi

func overwrite_by_map(map:TileMapLayer):
	Navi.region=map.get_used_rect()
	Navi.cell_size=map.tile_set.tile_size
	Navi.offset=Navi.cell_size/2
	Navi.update()
	Navi.fill_solid_region(Navi.region)

	for cell in map.get_used_cells():
		Navi.set_point_solid(cell,false)
