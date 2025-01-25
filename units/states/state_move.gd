class_name StateMove
extends State

@export var attack_state: State
@export var search_state: State

func enter_state():
	_entity.anim_player.play("walk")
	
	
func process(delta):
	if _entity.target != null:
		if _entity.position.distance_squared_to(_entity.destination) <= Game.ATTACK_RADIUS_SQR:
			_fsm.set_state(attack_state.name)
	else:
		_fsm.set_state(search_state.name)
	
	
func exit_state():
	pass
	
