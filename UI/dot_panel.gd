@tool
extends Panel
@export var color:Color
@export var number:int=2:
	set(n):
		number = n
		update_text()

var style:StyleBoxFlat

func update_text():
	if $Label:
		$Label.text=str(number)

func _ready() -> void:
	style = get_theme_stylebox("panel").duplicate()
	add_theme_stylebox_override("panel",style)
	style.bg_color=color
	
	update_text()
	$Label.resized.connect(_on_text_resize)
	
func _on_text_resize():
	size.x=$Label.size.x+10
