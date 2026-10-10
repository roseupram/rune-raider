extends DrawRequest
class_name DrawCircle

var center=Vector2.ZERO
var line_width=4
var radius=50
var color:Color
var points=32

func _init(center_,r,lw,colo=Color.WHITE) -> void:
	center=center_
	radius=r
	line_width=lw
	color=colo
	points=radius/10+32

func draw(n:RangeNode):
	n.draw_circle(center,radius,color,false,line_width)
