@tool
extends Panel
class_name CardUI

@onready var cost_node = $CostPanel
@onready var label_node =$Label
@onready var anim_node = $AnimationPlayer
@export var data: CardData:
	set(d):
		data=d
		_update_data()

var shortcuts:Array[InputEvent]


signal  focus(card:CardUI)


enum State{normal,hover,focus,unfocus}

var current_state:State=State.normal

func _shortcut_input(event: InputEvent) -> void:
	if shortcuts.size()==0:
		return
	for e:InputEvent in shortcuts:
		if e.is_match(event) and event.pressed:
			state_to(State.focus)
			return
	

# Called when the node enters the scene tree for the first time.
func _gui_input(event: InputEvent) -> void:
	#print(event)
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
			if current_state==State.hover:
				state_to(State.focus)
				accept_event()
func _ready() -> void:
	pass
	#size.x=size.y
func _update_data():
	if not is_node_ready(): await  ready
	#print(data)
	var description = data.ID+"_DESP"
	label_node.text=tr(description).format(data)
	cost_node.number=data.cost
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func unfocus():
	state_to(State.unfocus)

func state_to(s:State):
	if current_state==s:
		return
	match s:
		State.focus:
			anim_node.play("focus")
			focus.emit(self)
		State.unfocus:
			anim_node.play("normal")
		_:
			if current_state==State.focus:
				return
			else:
				anim_node.play({State.hover:"hover",
				State.normal:"normal"}[s])

	current_state=s


func _on_mouse_entered() -> void:
	state_to(State.hover)


func _on_mouse_exited() -> void:
	state_to(State.normal)
