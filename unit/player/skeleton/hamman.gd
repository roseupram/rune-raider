extends SubViewportContainer

@export var blur_strength=0.1

func blur(dir:Vector2):
	set_instance_shader_parameter("directoin",dir)
	set_instance_shader_parameter("strength",blur_strength)

func deblur():
	set_instance_shader_parameter("strength",0.0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deblur()
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
