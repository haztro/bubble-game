class_name StateSearch
extends State


@export var move_state: State


func _ready():
	pass

func enter_state():
	pass
	#_entity.anim_player.play("idle")
	#pass


func process(delta):
	var target = null
	var enemies = []
	if _entity.is_in_group("enemy"):
		enemies = get_tree().get_nodes_in_group("human")
	elif _entity.is_in_group("human"):
		enemies = get_tree().get_nodes_in_group("enemy")
		
	var smallest_distance = INF
	for e in enemies:
		var dist = _entity.position.distance_squared_to(e.position) 
		if dist < smallest_distance:
			target = e
			smallest_distance = dist
	
	if target != null:
		_entity.target = target
		_fsm.set_state(move_state.name)
	
	
func exit_state():
	pass
	
