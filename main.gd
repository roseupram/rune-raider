extends Node

var Camera_move_dir=Vector2.ZERO
var Camera_move_thresh=100
var Camera_move_speed=100

var select_card:CardData

var target_y = 0
#var effect_lib = load("res://cards/effect_library.gd").new()	
var effect_lib = EffectLibrary.new()

func _ready() -> void:
	GameContext.Player=$Player
	GameContext.Map=$Map
	GameContext.card_selected.connect(_on_card_selected)
	
	$Player.global_position = $Map.map_to_global(Vector2i(3,3))
	$Unit.global_position = $Map.map_to_global(Vector2i(6,1))
	var tile_size = $Map.tile_set.tile_size
	var map_rect = $Map.get_used_rect()
	$Camera.limit_top=$Map.to_global(map_rect.position*tile_size).y
	var screen_size = get_viewport().get_visible_rect().size
	$Camera.limit_bottom=$Map.to_global(map_rect.end*tile_size).y-screen_size.y
	
	$RangeLayer.clear()

	
func show_circle_range(radius):
	var pos = $Player.global_position
	$RangeLayer.clear()
	pos=$RangeLayer.to_local(pos)
	var posi = $RangeLayer.local_to_map(pos)
	for x in range(-radius,radius+1):
		for y in range(-radius,radius+1):
			if x==0 and y==0: continue
			var celli=posi+Vector2i(x,y)
			if $Map.isvalid(celli): $RangeLayer.enable(celli)

func _on_card_selected(card_data):
	show_circle_range(card_data.range)
	select_card=card_data

func _unhandled_input(event: InputEvent) -> void:
	#Camera_move_dir=Vector2.ZERO
	if event.is_action_released("click"):
		var pos = get_viewport().get_mouse_position()
		pos=$Camera.to_global(pos)
		if $RangeLayer.isvalid(pos) and select_card:
			var effect_fn:Callable = effect_lib[select_card.effect]
			GameContext.mouse_pos = $Map.snap_to_global(pos)
			if effect_fn:
				await effect_fn.call()
			else:
				push_error("no effect [%s]" % select_card.effect)
			GameContext.card_played.emit(select_card)
			$RangeLayer.clear()
			#show_circle_range(1)
	elif  event is InputEventMouseButton:
		if event.pressed:
			var cam_move=Vector2.ZERO
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				cam_move.y-=Camera_move_speed
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				cam_move.y+=Camera_move_speed
			$Camera.move_step(cam_move)
			
			
#func _process(delta: float) -> void:
	#var pos_y = $Camera.position.y 

	
	
	
