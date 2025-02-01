class_name Barracks
extends "res://world/building.gd"

var bubble_small_scene = preload("res://units/bubble_small.tscn")
var bubble_medium_scene = preload("res://units/bubble_medium.tscn")
var bubble_large_scene = preload("res://units/bubble_large.tscn")

var float_speed: float = 50.0
var spawning = false
var current_unit_type = Game.UNIT_TYPE.SMALL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	anim_player.seek(0.4)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
	
	
func add_bubble_node(unit_type) -> void:
	_audio_player.play()
	var bubble = null
	match unit_type:
		Game.UNIT_TYPE.SMALL:
			bubble = bubble_small_scene.instantiate()
		Game.UNIT_TYPE.MEDIUM:
			bubble = bubble_medium_scene.instantiate()
		Game.UNIT_TYPE.LARGE:
			bubble = bubble_large_scene.instantiate()

	bubble.position = position + Vector2(22, -22)
	get_parent().connect("run_to_next", bubble.run_to_next)
	get_parent().connect("start_battle", bubble.start_battle)
	get_parent().add_child(bubble)
	
	var dest = Vector2(randi_range(192, 384), randi_range(75, 190)) + Vector2(1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(bubble, "position", dest, bubble.position.distance_to(dest) / float_speed)
	tween.tween_callback(bubble.spawn_self)
	
	spawning = false
	anim_player.play("idle")
	get_tree().get_first_node_in_group("ui").set_buy_btns_disabled(false)
	
func new_bubble(unit_type) -> void:
	if anim_player.current_animation == "idle":
		spawning = true
		current_unit_type = unit_type
		anim_player.play("spawn")
	
	
# Called at end of "spawn" animation
func spawn_bubble() -> void:
	add_bubble_node(current_unit_type)
