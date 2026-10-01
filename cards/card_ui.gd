#@tool
extends Control
class_name CardHandUI

@onready var cost_node = $CostPanel
@export var label_node:Label
@onready var anim_node = $AnimationPlayer
@export var img_node:TextureRect
@export var data: CardData:
	set(d):
		data=d
		_update_data()

var shortcut_name:StringName


var discard:Callable
var get_enegy:Callable

signal  focus(card:CardHandUI,by_shortcut:bool)

enum State{normal,hover,focus,unfocus}
var current_state:State=State.normal

func _ready() -> void:
	anchor_top=0
	anchor_bottom=1.0

func _shortcut_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(shortcut_name):
		state_to(State.focus,true)
		get_viewport().set_input_as_handled()
	

# Called when the node enters the scene tree for the first time.
func _gui_input(_event: InputEvent) -> void:
	#print(event)
	if Input.is_action_just_pressed("select_card"):
		if current_state==State.hover:
			state_to(State.focus)
			accept_event()

func _update_data():
	if not is_node_ready(): await  ready
	#print(data)
	label_node.text=""
	for e in data.effects:
		var description = e.tr_key.to_upper()
		label_node.text+=tr(description).format(e)
	cost_node.number=data.cost
	img_node.texture=data.image
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func unfocus():
	state_to(State.unfocus)

func state_to(s:State,focus_by_shortcut=false):
	if current_state==s:
		return
	match s:
		State.focus:
			if get_enegy.call()<data.cost:
				anim_node.play("error")
				return
			anim_node.play("focus")
			focus.emit(self,focus_by_shortcut)
		State.unfocus:
			anim_node.play("normal")
		State.normal,State.hover:
			if current_state==State.focus:
				return
			else:
				anim_node.play({State.hover:"hover",
				State.normal:"normal"}[s])
	current_state=s

func played():
	if discard:
		discard.call()
	else:
		push_error("not define discard function")


func move_to(pos,time=0.1):
	var tw =get_tree().create_tween()
	tw.tween_property(self,"position",pos,time).set_trans(Tween.TRANS_SINE)


func _on_mouse_entered() -> void:
	state_to(State.hover)


func _on_mouse_exited() -> void:
	state_to(State.normal)
