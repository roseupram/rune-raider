extends Resource
class_name CardData

@export var ID: String
@export var cost: int
## Numeric magnitude of the card, used by effects as a default value
## and for the card's description (e.g. "Attack 6").
@export var value: int
## Effects executed in order when the card is played.
@export var effects: Array = []
@warning_ignore("shadowed_global_identifier")
@export var range: RangeType
