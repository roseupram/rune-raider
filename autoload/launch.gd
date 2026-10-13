extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var launch_scene=START_MENU
	if OS.has_feature("editor"):
		SceneManager.to_game()
	else:
		SceneManager.to_menu()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
		
