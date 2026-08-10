extends RefCounted
class_name  ActionManager
# autoload must be Node
signal  action_completed(action:ActionRequest)

var _pending_actions:Array[ActionRequest]=[]

func request(r:ActionRequest):
	_pending_actions.append(r)
	

func act():
	for a in _pending_actions:
		await a.execute()
		action_completed.emit(a)
	_pending_actions.clear()
