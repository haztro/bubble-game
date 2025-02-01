class_name StateMove
extends State

@export var attack_state: State
@export var search_state: State

var _timer: Timer = Timer.new()


func _ready():
	_timer.timeout.connect(_on_timer_timeout)
	_timer.wait_time = 0.2
	_timer.autostart = false
	_timer.one_shot = false
	add_child(_timer)
	

func _on_timer_timeout():
	_fsm.set_state(search_state.name)
	

func enter_state():
	_timer.start()
	_entity.anim_player.play("walk")
	
	
func process(delta):
	if _entity.target != null:
		_entity.destination = _entity.target.position
		_entity.destination.x += Game.ATTACK_DISTANCE * (-1 if _entity.position.x < _entity.target.position.x else 1)
		
		if abs(_entity.position.x - _entity.target.position.x) <= Game.ATTACK_DISTANCE_X:
			if abs(_entity.position.y - _entity.target.position.y) <= Game.ATTACK_DISTANCE_Y:
				_fsm.set_state(attack_state.name)
	else:
		_fsm.set_state(search_state.name)
	
	
func exit_state():
	_timer.stop()
	
