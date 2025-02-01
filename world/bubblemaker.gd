class_name BubbleMaker
extends "res://world/building.gd"

@onready var _money_timer: Timer = get_node("Timer")

var money_bubble_scene = preload("res://world/money_bubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	anim_player.seek(0.4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	anim_player.speed_scale = speed_function()
	anim_player.play("money")
	
	
func spawn_bubble():
	if Game.game_state == Game.GAME_STATE.BASE:
		_audio_player.play()
	var mb = money_bubble_scene.instantiate()
	mb.position = position
	mb.position.y -= 10
	mb.worth = Game.worth_tier
	mb.set_worth_card(mb.worth)
	get_parent().add_child(mb)
	
	
func speed_function():
	return Game.speed_tier * 1
	
	
func upgrade():
	super.upgrade()		# increase tier
	_money_timer.wait_time = 1 / float(speed_function())
	_money_timer.start()
	
