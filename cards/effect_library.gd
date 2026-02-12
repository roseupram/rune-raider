extends RefCounted
class_name EffectLibrary

func move():
	await GameContext.Player.move(GameContext.mouse_pos)
func attack():
	await GameContext.Player.attack()
