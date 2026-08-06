@tool
extends Control
@onready var cost_node = $Panel/CostPanel
@onready var label_node =$Panel/Label
@onready var anim_node = $AnimationPlayer
@export var data: CardData:
	set(d):
		data=d
		_update_data()

signal  focus


enum State{normal,hover,focus,unfocus}

var current_state:State=State.normal

# Called when the node enters the scene tree for the first time.
func _gui_input(event: InputEvent) -> void:
	#print(event)
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			state_to(State.focus)
			accept_event()
func _ready() -> void:
	pass # Replace with function body.
func _update_data():
	if not is_node_ready(): await  ready
	var description = data.ID+"_DESP"
	label_node.text=tr(description).format(data)
	cost_node.number=data.cost
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func unfocus():
	state_to(State.unfocus)

func state_to(s):
	if current_state==s:
		return
	match s:
		State.focus:
			anim_node.play("focus")
			focus.emit()
		State.unfocus:
			anim_node.play("normal")
		_:
			if current_state!=State.focus:
				anim_node.play({State.hover:"hover",
				State.normal:"normal"}[s])
			else:
				return
	
	current_state=s


func _on_mouse_entered() -> void:
	state_to(State.hover)


func _on_mouse_exited() -> void:
	state_to(State.normal)
