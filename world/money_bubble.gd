extends Node2D


var worth = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	Game.bubble_bux += worth
	queue_free()
