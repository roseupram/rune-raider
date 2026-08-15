@tool
extends Control

@export var value:int = 2:
	set=set_value
@export var max_value:int = 10:
	set=set_max_value
@export var color:Color=Color.RED:
	set=set_color
	
@export var stat_node:StatComponent:
	set(n):
		max_value=n.max_value
		value=n.value
		n.changed.connect(_on_changed)
	
func _on_changed(from,to,max_v):
	max_value=max_v
	#value=current
	var tween = get_tree().create_tween()
	tween.tween_property(self,"value",to,.1)

func set_color(c):
	color=c
	$ProgressBar.tint_progress=c
	
	
func set_max_value(mv):
	if $ProgressBar:
		$ProgressBar.max_value=mv
	max_value=mv
	value=value

func set_value(v):
	value=min(v,max_value)
	if $Label:
		$Label.text="%d/%d" % [ value,max_value]
		$ProgressBar.value=value
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value=value
	max_value=max_value
	$ProgressBar.tint_progress=color
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
