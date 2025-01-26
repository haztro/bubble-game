class_name StateRun
extends State

@export var idle_state: State


func enter_state():
	_entity.anim_player.play("walk")
	
	
func process(delta):
	if _entity.position.distance_squared_to(_entity.destination) < 100:
		_fsm.set_state(idle_state.name)
	
	
func exit_state():
	pass
	
