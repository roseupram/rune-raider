extends DrawRequest
class_name DrawCircle

var center=Vector2.ZERO
var line_width=4
var radius=50
var color:Color
var points=32

func _init(c,r,lw,colo=Color.WHITE) -> void:
	center=c
	radius=r
	line_width=lw
	color=colo
	points=radius/10+32
