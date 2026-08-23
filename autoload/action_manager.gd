extends RefCounted
class_name  ActionManager
# autoload must be Node
signal  action_completed(action:ActionRequest)
enum State{Idle,Acting}
var current_state:=State.Idle
var act_pointer=0

var _pending_actions:Array[ActionRequest]=[]

func request(r:ActionRequest):
	_pending_actions.append(r)
	
func clear():
	_pending_actions.clear()
	act_pointer=0	

func act():
	if current_state==State.Acting: return
	current_state=State.Acting
	while act_pointer<_pending_actions.size():
		# prints(act_pointer,_pending_actions.size())
		var a = _pending_actions[act_pointer]
		await a.execute()
		action_completed.emit(a)
		act_pointer+=1
	#_pending_actions.clear()
	current_state=State.Idle
