class_name StateAttack
extends State

@export var search_state: State
@export var move_state: State


func _ready():
	pass

func enter_state():
	_entity.anim_player.play("attack")
	_entity._sprite.set_flip_h(1 if _entity.position > _entity.target.position else 0)


func process(delta):
	if _entity.target != null:
		if _entity.position.distance_squared_to(_entity.destination) > Game.ATTACK_RADIUS_SQR:
			await _entity.anim_player.animation_finished
			_fsm.set_state(move_state.name)
	else:
		_fsm.set_state(search_state.name)
	
	
func exit_state():
	pass
	
