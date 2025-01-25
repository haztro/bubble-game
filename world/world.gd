extends Node2D

signal run_to_next

@onready var progress_bar = get_node("CanvasLayer/Control/MarginContainer/ProgressBar")
@onready var round_timer = get_node("RoundTimer")

var bubble_small_scene = preload("res://units/bubble_small.tscn")
var bubble_medium_scene = preload("res://units/bubble_medium.tscn")
var bubble_large_scene = preload("res://units/bubble_large.tscn")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	round_timer.start()	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left click"):
		spawn_bubble(get_global_mouse_position(), 'large', false)
	if Input.is_action_just_pressed("right click"):
		spawn_bubble(get_global_mouse_position(), 'large', true)
		
	progress_bar.value = int(100 * (round_timer.time_left / round_timer.wait_time))


func spawn_bubble(bubble_pos, bubble_size, is_enemy):
	var bubble = null
	if bubble_size == 'small':
		bubble = bubble_small_scene.instantiate()
	elif bubble_size == 'medium':
		bubble = bubble_medium_scene.instantiate()
	elif bubble_size == 'large':
		bubble = bubble_large_scene.instantiate()
	
	bubble.is_enemy = is_enemy
	bubble.position = bubble_pos
	add_child(bubble)
	


func _on_round_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Camera2D, "position", Vector2($Camera2D.position.x+384/2, $Camera2D.position.y), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	#emit_signal("run_to_next")
