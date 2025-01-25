class_name StateIdle
extends State


func _ready():
	pass

func enter_state():
	_entity.anim_player.play("idle")


func process(delta):
	pass
	
	
func exit_state():
	pass
	
