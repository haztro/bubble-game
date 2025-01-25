extends Node2D


var bubble_small_scene = preload("res://units/bubble_small.tscn")
var bubble_medium_scene = preload("res://units/bubble_medium.tscn")
var bubble_large_scene = preload("res://units/bubble_large.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	
