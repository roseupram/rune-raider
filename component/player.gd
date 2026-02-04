extends AnimatedSprite2D

# glory kill to restore enegy and hp
# enegy like rescouce, may not be auto restored, 
# action-based (enemy moves when you use 2 move or 3 move)
# everything is a touchable item, like potion, it drops on ground, you can pick it, enemy also
# 

var cards
var enegy
var enegy_max

func attack():
	var tween=get_tree().create_tween()
	rotation = deg_to_rad(-120)
	$Node2D.show()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"rotation",0,0.2)
	tween.tween_property($Node2D,"rotation",deg_to_rad(120),.1)
	await  tween.finished
	$Node2D.rotation=0
	$Node2D.hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Node2D.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
