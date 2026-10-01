extends Resource
class_name CardData

@export var ID: String
@export var cost: int
@export var effects: Array[EffectData] = []
@export var image:Texture2D

static  func sort_by_ID(a:CardData,b:CardData):
	return a.ID<b.ID
