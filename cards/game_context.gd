extends Node

signal card_played(card_data)
signal card_selected(card_data:CardData)

var mouse_pos=Vector2.ZERO

var Player
var Map:BaseTileMap :
	set(m):
		Map=m
		update_navi()

var Navi=AStarGrid2D.new()

func find_path(start,end):
	if start is Vector2:
		start=Map.global_to_map(start)
	if end is Vector2:
		end=Map.global_to_map(end)
	return Navi.get_point_path(start,end)

func update_navi():
	if not Map:
		return
	Navi.region=Map.get_used_rect()
	Navi.cell_size=Map.tile_set.tile_size
	Navi.offset=Navi.cell_size/2
	Navi.update()
	Navi.fill_solid_region(Navi.region)
	for cell in Map.get_used_cells():
		Navi.set_point_solid(cell,false)
