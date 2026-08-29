extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var launch_scene=START_MENU
	if OS.has_feature("editor"):
		EventBus.to_game()
	else:
		EventBus.to_menu()
	
		
