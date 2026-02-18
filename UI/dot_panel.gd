@tool
extends Panel

@export var number:int=2:
	set(n):
		number = n
		update_text()
func update_text():
	if $Label:
		$Label.text=str(number)

func _ready() -> void:
	update_text()
	$Label.resized.connect(_on_text_resize)
	
func _on_text_resize():
	size.x=$Label.size.x+10
