extends Node2D

signal run_to_next
signal start_battle

@onready var round_timer = get_node("RoundTimer")
@onready var _camera: Camera2D
@onready var _ui = get_node("CanvasLayer/ui")
@onready var _barracks = $barracks
@onready var _bubble_maker = $bubblemaker


var bubble_small_scene = preload("res://units/bubble_small.tscn")
var bubble_medium_scene = preload("res://units/bubble_medium.tscn")
var bubble_large_scene = preload("res://units/bubble_large.tscn")

var menu = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func init_base():
	_ui.visible = true
	_ui.set_progress_bar_visible(true)
	_ui.show_buttons()
	Game.game_state = Game.GAME_STATE.BASE
	await get_tree().create_timer(1)
	_bubble_maker.get_node("Timer").start()
	round_timer.start()	
	
	
func transfer_units(reset=false):
	for unit in get_tree().get_nodes_in_group("human"):
		unit.reparent(self if reset else get_parent(), true)
		unit.position += Vector2(-384, 0) if reset else Vector2.ZERO

	
func spawn_bubble(bubble_pos, unit_type, is_enemy):
	var bubble = null
	match unit_type:
		Game.UNIT_TYPE.SMALL:
			bubble = bubble_small_scene.instantiate()
		Game.UNIT_TYPE.MEDIUM:
			bubble = bubble_medium_scene.instantiate()
		Game.UNIT_TYPE.LARGE:
			bubble = bubble_large_scene.instantiate()
	bubble.is_enemy = is_enemy
	bubble.position = bubble_pos
	bubble.split = true
	add_child(bubble)
	
	
func check_win():
	var num_human = get_tree().get_node_count_in_group("human")
	var num_enemy = get_tree().get_node_count_in_group("enemy")
	
	if num_human <= 0:
		$Timer.stop()
		Game.reset_game()
		#await get_tree().create_timer(3)
		#get_tree().reload_current_scene()
	elif num_enemy <= 0:
		Game.level += 1 
		win_animation()
		$Timer.stop()
		
		
func win_animation():
	await get_tree().create_timer(Game.CELEBRATION_TIME)
	emit_signal("run_to_next")

	var tween = get_tree().create_tween()
	tween.tween_property(_barracks, "position", _barracks.position + Vector2(384*1.5, 0), Game.BUILDING_FLY_TIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.set_parallel()
	tween.tween_property(_bubble_maker, "position", _bubble_maker.position + Vector2(384*1.5, 0), Game.BUILDING_FLY_TIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)	
	await tween.finished

	get_tree().current_scene.load_level()
	

func _on_round_timer_timeout() -> void:
	_ui.set_progress_bar_visible(false)
	_ui.hide_buttons()
	
	var tween = get_tree().create_tween()   
	tween.tween_property(_camera, "position", Vector2(192, 0), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	
	Game.game_state = Game.GAME_STATE.FIGHT
	$Timer.start()
	emit_signal("start_battle")
	
	
func _on_timer_timeout() -> void:
	check_win()
