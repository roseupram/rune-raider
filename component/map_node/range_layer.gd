extends BaseTileMap
class_name RangeLayer
enum RangeType {Blue,Red}

@export var base_map:BaseTileMap
const SELECTED_BOX = preload("uid://b3q585b05g37")
var selected_box:Sprite2D
var mouse_pos:Vector2

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_pos=get_global_mouse_position()
		if get_id(mouse_pos)==-1:
			selected_box.hide()
			return
		else:
			selected_box.show()
		var center = snap_to_global(mouse_pos)
		selected_box.global_position=center

func enable(cell:Vector2i,tile_mask:int):
	if not base_map:
		printerr("not assgined BaseTileMap")

	var id_m = base_map.get_id(cell)
	#print(cell,id_m)
	var not_target_tile =id_m <=0 or not (id_m & tile_mask) 
	if not_target_tile:
		return
	if tile_mask & BaseTileMap.Type.Occupied:
		z_index=99
	else:
		z_index=0
	var type = RangeType.Red
	if tile_mask==BaseTileMap.Type.Player:
		type=RangeType.Blue
		z_index=99
	set_cell(cell,type,Vector2i(0,0))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var box = SELECTED_BOX.instantiate()
	add_child(box)
	selected_box=box
	box.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
