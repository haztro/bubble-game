class_name Barracks
extends "res://world/building.gd"

var bubble_small_scene = preload("res://units/bubble_small.tscn")
var bubble_medium_scene = preload("res://units/bubble_medium.tscn")
var bubble_large_scene = preload("res://units/bubble_large.tscn")

var float_speed: float = 50.0
var current_bubble_size = "small"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	anim_player.seek(0.4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
	
	
func add_bubble_node(bubble_size):
	var bubble = null
	if bubble_size == 'small':
		bubble = bubble_small_scene.instantiate()
		get_parent().buy_small.disabled = !(Game.bubble_bux >= Game.SMALL_COST)
	elif bubble_size == 'medium':
		bubble = bubble_medium_scene.instantiate()
		get_parent().buy_med.disabled = !(Game.bubble_bux >= Game.SMALL_MED)
	elif bubble_size == 'large':
		bubble = bubble_large_scene.instantiate()
		get_parent().buy_large.disabled = !(Game.bubble_bux >= Game.SMALL_LARGE)

	bubble.position = position + Vector2(22, -22)
	get_parent().connect("run_to_next", bubble.run_to_next)
	get_parent().connect("start_battle", bubble.start_battle)
	get_parent().add_child(bubble)
	
	var dest = Vector2(randi_range(0, 100), randi_range(75, 190)) + Vector2(1, 0) * 384 * (Game.level-1)
	var tween = get_tree().create_tween()
	tween.tween_property(bubble, "position", dest, bubble.position.distance_to(dest) / float_speed)
	tween.tween_callback(bubble.spawn_self)
	
func new_bubble(bubble_size):
	current_bubble_size = bubble_size
	$AnimationPlayer.play("spawn")
	
	
func spawn_bubble():
	add_bubble_node(current_bubble_size)
	pass


func upgrade():
	super.upgrade()
