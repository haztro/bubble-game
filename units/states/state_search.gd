class_name StateSearch
extends State


@export var move_state: State


func _ready():
	pass

func enter_state():
	_entity.anim_player.play("idle")


func process(delta):
	var target = null
	var enemies = []
	if _entity.is_in_group("enemy"):
		enemies = get_tree().get_nodes_in_group("human")
	elif _entity.is_in_group("human"):
		enemies = get_tree().get_nodes_in_group("enemy")
	target = enemies.pick_random()
	
	if target != null:
		_entity.target = target
		_fsm.set_state(move_state.name)
	
	
func exit_state():
	pass
	
