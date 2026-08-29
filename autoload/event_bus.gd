extends Node
## EventBus

const MAIN_GAME = preload("uid://cl1r60rn8mlxx")
const START_MENU = preload("uid://bhl3tkd7kgv07")


signal unit_moved(from:Vector2,to:Vector2,act:Node2D)
## for hp, enegy change
signal stat_changed(from,to,source:StatComponent)
## EventBus.turn_end => BattaleManager
signal turn_end()
signal enemy_spawn(node)

var cursor_normal = preload("res://images/cursor.svg")

func _ready() -> void:
	print(MAIN_GAME,"\n",START_MENU)
	#var clipboard = DisplayServer.clipboard_get()
	#print(clipboard)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		Input.set_custom_mouse_cursor(cursor_normal,Input.CURSOR_ARROW,Vector2(1,1))
	elif  Input.is_action_just_released("click"):
		Input.set_custom_mouse_cursor(cursor_normal)

func to_game():
	get_tree().change_scene_to_packed.call_deferred(MAIN_GAME)
func to_menu():
	get_tree().change_scene_to_packed.call_deferred(START_MENU)
