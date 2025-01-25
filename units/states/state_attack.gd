class_name StateAttack
extends State

@export var search_state: State
@export var move_state: State


func _ready():
	pass

func enter_state():
	pass


func process(delta):
	if _entity.target != null:
		pass
		if _entity.position.distance_squared_to(_entity.target.position) > Game.ATTACK_RADIUS_SQR:
			print("TOO FAR")
			_fsm.set_state(move_state.name)
	else:
		_fsm.set_state(search_state.name)
	
	
func exit_state():
	pass
	
