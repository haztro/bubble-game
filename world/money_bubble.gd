extends Node2D


var worth = 1
var flight_time = 0.8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = flight_time - 0.2
	$Timer2.wait_time = flight_time + 0.1
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y - 60), flight_time*3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	$Timer.start()
	$Timer2.start()


func set_worth_card(val):
	$number.frame = worth - 1


func _on_pop_animation_finished() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	Game.bubble_bux += worth
	get_tree().get_first_node_in_group("world").update_buttons()
	$pop.play()
	$AudioStreamPlayer2D.set_pitch_scale(randf_range(0.85, 1.15))
	$AudioStreamPlayer2D.play()


func _on_timer_2_timeout() -> void:
	$number.visible = true
	pass
