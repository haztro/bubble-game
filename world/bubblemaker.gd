class_name BubbleMaker
extends "res://world/building.gd"


var money_bubble_scene = preload("res://world/money_bubble.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	anim_player.seek(0.4)
	tier = 1
	
	if tier > 0:
		$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	anim_player.speed_scale = speed_function()
	anim_player.play("money")
	
	
func spawn_bubble():
	var mb = money_bubble_scene.instantiate()
	mb.position.y -= 10
	mb.worth = worth_function()
	mb.set_worth_card(mb.worth)
	add_child(mb)
	
	
	
func speed_function():
	return tier * 1
	

func worth_function():
	return tier
	
	
func upgrade():
	super.upgrade()
	$Timer.wait_time = speed_function()
	
