extends Node

signal card_played(card_data)
signal card_selected(card_data:CardData)

var mouse_pos=Vector2.ZERO

var RNG=RandomNumberGenerator.new()
var action_queue=[]

var Player
var Navi=AStarGrid2D.new()
var Map:BaseTileMap :
	set(m):
		Map=m
		update_navi()

func _ready() -> void:
	# randomize()
	RNG.seed="this is a seed".hash()
	print(RNG.randi()% 100)

func rand_pos()->Vector2:
	var all_cell = Map.get_used_cells()
	all_cell = all_cell.filter(func(_cell): return 1)
	var celli = all_cell[RNG.randi()%all_cell.size()]
	return Map.map_to_global(celli)

func add_action(act,data):
	action_queue.push_back({action=act,data=data})

func find_path(start,end):
	var restore_to_solid=[]
	if start is Vector2:
		start=Map.global_to_map(start)
	if end is Vector2:
		end=Map.global_to_map(end)
	if Navi.is_point_solid(start):
		Navi.set_point_solid(start,false)
		restore_to_solid.push_back(start)
		
	var path = Navi.get_point_path(start,end)
	
	for celli in restore_to_solid:
		Navi.set_point_solid(celli,true)
	return path

func set_navi_solid(pos,is_obstacle=true):
	if pos is Vector2:
		pos=Map.global_to_map(pos)
	Navi.set_point_solid(pos,is_obstacle)

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
