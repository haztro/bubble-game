extends Control

@onready var _camera: Camera2D = get_node("SubViewportContainer/SubViewport/Camera2D")
@onready var _parallax: Node2D = get_node("SubViewportContainer/SubViewport/Camera2D/ParallaxBG")
@onready var _menu = get_node("Menu")
@onready var _viewport = get_node("SubViewportContainer/SubViewport")


var world_scene = preload("res://world/world.tscn")

var level1_scene = preload("res://levels/level_1.tscn")
var level2_scene = preload("res://levels/level_2.tscn")
var level3_scene = preload("res://levels/level_3.tscn")
var level4_scene = preload("res://levels/level_4.tscn")
var level5_scene = preload("res://levels/level_5.tscn")
var level6_scene = preload("res://levels/level_6.tscn")
var level7_scene = preload("res://levels/level_7.tscn")
var level8_scene = preload("res://levels/level_8.tscn")

var all_levels = [
	level1_scene, 
	level2_scene, 
	level3_scene, 
	level4_scene, 
	level5_scene, 
	level6_scene, 
	level7_scene,
	level8_scene
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_start_game() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(_camera, "position", Vector2(-384, _camera.position.y), 2.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.set_parallel()
	tween.tween_property(_menu, "position", Vector2(_menu.position.x - 384, _menu.position.y), 2.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	var world = load_level()
	
	
func load_level():
	var current_world = get_tree().get_first_node_in_group("world")
	if current_world != null:
		_parallax.offset = (384 + 192) * Game.level
		_camera.position.x = -384
		current_world.transfer_units(false)
		current_world.queue_free()

	var world = world_scene.instantiate()
	world._camera = _camera
	_viewport.add_child(world)
	world.transfer_units(true)
	
	# Add enemies 
	var level = all_levels[Game.level].instantiate()
	level.position = Vector2(384 + 192/2, 108)
	world.add_child(level)

	var tween = get_tree().create_tween()
	var ease = Tween.EASE_OUT if Game.level == 0 else Tween.EASE_IN_OUT
	tween.set_parallel()
	tween.tween_property(world._camera, "position", Vector2(0, 0), 2).set_ease(ease).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(world.init_base).set_delay(1.5)

	return world
	
	
