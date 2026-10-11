extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc_menu"):
		show()
		get_viewport().set_input_as_handled()
		

func _on_return():
	hide()

func _on_back_to_menu():
	EventBus.to_menu()