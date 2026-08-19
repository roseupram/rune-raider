extends Node
@warning_ignore("unused_signal")
signal unit_moved(from,to,act:Node2D)
@warning_ignore("unused_signal")
signal stat_changed(from,to,source:StatComponent)

var cursor_normal = preload("res://images/cursor.svg")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		Input.set_custom_mouse_cursor(cursor_normal,Input.CURSOR_ARROW,Vector2(1,1))
	elif  Input.is_action_just_released("click"):
		Input.set_custom_mouse_cursor(cursor_normal)
