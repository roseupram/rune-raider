extends BaseTileMap
class_name RangeLayer
enum RangeType {Blue,Red}

signal confirmed(posi:Vector2i)

@export var base_map:BaseTileMap:
	set(map):
		base_map=map
		position = map.position

const SELECTED_BOX =preload("uid://b3q585b05g37")
var selected_box:Sprite2D
var mouse_pos:Vector2

var confirm_events=InputMap.action_get_events("confirm")

enum State{Idle,Show_range,Wait_Confirm,Confirmed}
var current_state=State.Idle

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		check_tile_select()
	elif current_state==State.Wait_Confirm:
		if Input.is_action_just_released("confirm") and check_tile_select():
			state_to(State.Confirmed)
			get_viewport().set_input_as_handled()
		
func check_tile_select():
	mouse_pos=get_global_mouse_position()
	if get_id(mouse_pos)==-1:
		selected_box.hide()
		return false
	else:
		state_to(State.Wait_Confirm)
		return true

# show_range-> check mouse_pos is tile -> show_select_box
func state_to(s:State):
	match s:
		State.Confirmed:
			var pos_i = global_to_map(mouse_pos)
			confirmed.emit(pos_i)
			state_to(State.Idle)
		State.Wait_Confirm:
			var center = snap_to_global(mouse_pos)
			selected_box.global_position=center
			selected_box.show()
		State.Idle:
			clear()
			selected_box.hide()
	current_state=s
func idle():
	state_to(State.Idle)

func enable(cell:Vector2i,tile_mask:int):
	if not base_map:
		push_error("not assgined BaseTileMap")

	var id_m = base_map.get_id(cell)
	#print(cell,id_m)
	var not_target_tile =id_m <=0 or not (id_m & tile_mask) 
	if not_target_tile:
		return
	if tile_mask & BaseTileMap.Type.Enemy:
		z_index=99
	else:
		z_index=0
	var type = RangeType.Red
	if tile_mask==BaseTileMap.Type.Player:
		type=RangeType.Blue
		z_index=99
	set_cell(cell,type,Vector2i(0,0))
	#check_tile_select()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var box = SELECTED_BOX.instantiate()
	add_child(box)
	selected_box=box
	box.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
