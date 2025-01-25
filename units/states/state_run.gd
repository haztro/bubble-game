class_name StateRun
extends State

@export var idle_state: State


func enter_state():
	_entity.anim_player.play("walk")
	
	
func process(delta):
	if _entity.target != null:
		pass
	
	
func exit_state():
	pass
	
