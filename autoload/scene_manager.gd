extends CanvasLayer

const MAIN_GAME = preload("uid://cl1r60rn8mlxx")
const START_MENU = preload("uid://bhl3tkd7kgv07")

var transiting=false
var colorect

func _ready() -> void:
	layer=999
	colorect=ColorRect.new()
	colorect.color = Color.BLACK
	colorect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	colorect.modulate.a=0
	colorect.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(colorect)

func change_scene(sc):
	with_transit(get_tree().change_scene_to_packed.bind(sc))

func quit():
	with_transit(get_tree().quit)

func with_transit(f:Callable,tw_time=0.2):
	if transiting: return

	colorect.mouse_filter=Control.MOUSE_FILTER_STOP
	transiting=true
	var tween = create_tween()
	tween.tween_property(colorect,"modulate:a",1.0,tw_time)
	await  tween.finished

	await  f.call()
	await get_tree().process_frame


	
	var t = create_tween()
	t.tween_property(colorect,"modulate:a",0.0,tw_time)
	await  t.finished

	colorect.mouse_filter=Control.MOUSE_FILTER_IGNORE
	transiting=false

func to_game():
	change_scene(MAIN_GAME)
func to_menu():
	change_scene(START_MENU)