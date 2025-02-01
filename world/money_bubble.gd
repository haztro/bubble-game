extends Node2D

@onready var _audio_player: AudioStreamPlayer = get_node("AudioStreamPlayer")
@onready var _pop_animation: AnimatedSprite2D = get_node("pop")

var worth = 1
var flight_time = 2.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y - 60), flight_time).set_ease(Tween.EASE_IN)
	
	var pop_tween = get_tree().create_tween()
	pop_tween.tween_interval(1) 
	pop_tween.tween_callback(_bubble_pop)


func set_worth_card(val):
	$value.frame = worth - 1


func _on_pop_animation_finished() -> void:
	queue_free()


func _bubble_pop() -> void:
	Game.bubble_bux += worth
	get_tree().get_first_node_in_group("ui").on_money_change()
	_pop_animation.play()
	if Game.game_state == Game.GAME_STATE.BASE:
		_audio_player.play()
	$value.visible = true
