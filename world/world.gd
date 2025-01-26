extends Node2D

signal run_to_next
signal start_battle

@onready var progress_bar = get_node("CanvasLayer/Control/MarginContainer/VBoxContainer/ProgressBar")
@onready var buy_small = get_node("CanvasLayer/Control/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/buy_small")
@onready var buy_med = get_node("CanvasLayer/Control/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/buy_med")
@onready var buy_large = get_node("CanvasLayer/Control/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/buy_large")
@onready var buy_upgrade = get_node("CanvasLayer/Control/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer4/buy_upgrade")
@onready var money_label = get_node("CanvasLayer/Control/MarginContainer/TextureButton/Label")
@onready var upgrade_label = get_node("CanvasLayer/Control/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer4/Label")

@onready var speed_upgrade = get_node("CanvasLayer/Control/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer5/speed_upgrade")
@onready var value_upgrade = get_node("CanvasLayer/Control/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer6/value_upgrade")

@onready var buttons = get_node("CanvasLayer/Control/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer")
@onready var round_timer = get_node("RoundTimer")

var bubble_small_scene = preload("res://units/bubble_small.tscn")
var bubble_medium_scene = preload("res://units/bubble_medium.tscn")
var bubble_large_scene = preload("res://units/bubble_large.tscn")

var level1_scene = preload("res://levels/level_1.tscn")
var level2_scene = preload("res://levels/level_2.tscn")
var level3_scene = preload("res://levels/level_3.tscn")
var level4_scene = preload("res://levels/level_4.tscn")
var level5_scene = preload("res://levels/level_5.tscn")
var level6_scene = preload("res://levels/level_6.tscn")
var level7_scene = preload("res://levels/level_7.tscn")
var level8_scene = preload("res://levels/level_8.tscn")


var all_levels = [level1_scene, 
				level2_scene, 
				level3_scene, 
				level4_scene, 
				level5_scene, 
				level6_scene, 
				level7_scene,
				level8_scene]

var menu = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$menu_music.play()
	for bubble in get_tree().get_nodes_in_group("bubble"):
		start_battle.connect(bubble.start_battle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = int(100 * (round_timer.time_left / round_timer.wait_time))
	money_label.text = str(Game.bubble_bux)

	if $barracks.tier == 0:
		buy_upgrade.disabled = !(Game.bubble_bux >= Game.BARRACKS_TIER1_COST)
	elif $barracks.tier == 1:
		buy_upgrade.disabled = !(Game.bubble_bux >= Game.BARRACKS_TIER2_COST)
		
	speed_upgrade.disabled = (Game.bubble_bux < Game.UPGRADE_SPEED_COST or $bubblemaker.tier >= Game.MAX_SPEED)
	value_upgrade.disabled = (Game.bubble_bux < Game.UPGRADE_WORTH_COST or $bubblemaker.worth >= Game.MAX_WORTH)
		
	
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
	bubble.split = true
	add_child(bubble)
	
	
func check_win():
	var num_human = get_tree().get_node_count_in_group("human")
	var num_enemy = get_tree().get_node_count_in_group("enemy")
	
	if num_human <= 0:
		$Timer.stop()
		Game.bubble_bux	= 30
		Game.UPGRADE_SPEED_COST = 20
		Game.UPGRADE_WORTH_COST = 20
		await get_tree().create_timer(3)
		get_tree().reload_current_scene()
	elif num_enemy <= 0:
		win_animation()
		$Timer.stop()
		
		
func win_animation():
	await get_tree().create_timer(Game.CELEBRATION_TIME)
	emit_signal("run_to_next")
	var tween = get_tree().create_tween()
	tween.tween_property($barracks, "position", $barracks.init_position + Vector2(384*Game.level, 0), Game.BUILDING_FLY_TIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.set_parallel()
	tween.tween_property($bubblemaker, "position", $bubblemaker.init_position + Vector2(384*Game.level, 0), Game.BUILDING_FLY_TIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	$base_screen.play()
	tween.tween_property($base_screen, "volume_db", 0, 2)
	
	await get_tree().create_timer(Game.CAMERA_BUILDING_DELAY)

	var tween2 = get_tree().create_tween()
	tween2.tween_property($Camera2D, "position", Vector2($Camera2D.position.x+384/2, $Camera2D.position.y), Game.CAM_TO_BASE_TIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween2.tween_callback(start_base)

	
func start_base():
	var tween = get_tree().create_tween()
	tween.tween_property(buttons, "position", Vector2(0, buttons.position.y), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	Game.level += 1
	if Game.level >= Game.MAX_LEVELS:
		Game.level = 1
		
	Game.mode = "base"
	$RoundTimer.start()
	progress_bar.modulate.a = 1
	var lvl = all_levels[Game.level-1].instantiate()
	lvl.position = Vector2(Game.level * 384 - 384/4, 125)
	add_child(lvl)
	for enemy in get_tree().get_nodes_in_group("enemy"):
		start_battle.connect(enemy.start_battle)
	


func _on_round_timer_timeout() -> void:
	progress_bar.modulate.a = 0
	var tween = get_tree().create_tween()   
	tween.tween_property($Camera2D, "position", Vector2($Camera2D.position.x+384/2, $Camera2D.position.y), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.set_parallel()
	tween.tween_property(buttons, "position", Vector2(-384/2, buttons.position.y), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property($base_screen, "volume_db", -80, 2)
	await tween.finished
	
	$base_screen.stop()
	
	Game.mode = "battle"
	$Timer.start()
	emit_signal("start_battle")
	
	



func _on_timer_timeout() -> void:
	check_win()


func _on_buy_upgrade_pressed() -> void:
	$button.play()
	if $barracks.tier == 0:
		if Game.bubble_bux >= Game.BARRACKS_TIER1_COST:
			if buy_med.get_parent().visible == false:
				Game.bubble_bux -= Game.BARRACKS_TIER1_COST
				buy_med.get_parent().visible = true
				$barracks.upgrade()
				upgrade_label.text = "-" + str(Game.BARRACKS_TIER2_COST)
				
	elif $barracks.tier == 1:
		if Game.bubble_bux >= Game.BARRACKS_TIER2_COST:
			if buy_large.get_parent().visible == false:
				Game.bubble_bux -= Game.BARRACKS_TIER2_COST
				buy_large.get_parent().visible = true
				$barracks.upgrade()
				buy_upgrade.get_parent().visible = false


func update_buttons():
	buy_small.disabled = !(Game.bubble_bux >= Game.SMALL_COST)
	buy_med.disabled = !(Game.bubble_bux >= Game.MED_COST)
	buy_large.disabled = !(Game.bubble_bux >= Game.LARGE_COST)


func _on_buy_small_pressed() -> void:
	$button.play()
	if Game.bubble_bux >= Game.SMALL_COST:
		Game.bubble_bux -= Game.SMALL_COST
		buy_small.disabled = true
		$barracks.new_bubble("small")

	#buy_small.disabled = !(Game.bubble_bux >= Game.SMALL_COST)


func _on_buy_med_pressed() -> void:
	$button.play()
	if Game.bubble_bux >= Game.MED_COST:
		Game.bubble_bux -= Game.MED_COST
		buy_med.disabled = true
		$barracks.new_bubble("medium")
		
	#buy_med.disabled = !(Game.bubble_bux >= Game.MED_COST)
		


func _on_buy_large_pressed() -> void:
	$button.play()
	if Game.bubble_bux >= Game.LARGE_COST:
		Game.bubble_bux -= Game.LARGE_COST
		buy_large.disabled = true
		$barracks.new_bubble("large")
		
	#buy_large.disabled = !(Game.bubble_bux >= Game.LARGE_COST)
		


func _on_title_screen_finished() -> void:
	$bubblemaker.get_node("Timer").start()
	
	round_timer.start()	
	$CanvasLayer/Control.visible = true
	menu = false
	$base_screen.play()
	var tween = get_tree().create_tween()
	tween.tween_property($menu_music, "volume_db", -80, 2)
	tween.tween_property($base_screen, "volume_db", 0, 0.3)
	await tween.finished
	$menu_music.stop() 


func _on_speed_upgrade_pressed() -> void:
	$button.play()
	if Game.bubble_bux >= Game.UPGRADE_SPEED_COST:
		Game.bubble_bux -= Game.UPGRADE_SPEED_COST
		$bubblemaker.upgrade()
		Game.inc_speed_cost($bubblemaker.tier)
		if $bubblemaker.tier >= Game.MAX_SPEED:
			speed_upgrade.get_parent().modulate.a = 0
		speed_upgrade.get_parent().get_node("Label").text = '-'+str(Game.UPGRADE_SPEED_COST)


func _on_value_upgrade_pressed() -> void:
	$button.play()
	if Game.bubble_bux >= Game.UPGRADE_WORTH_COST:
		Game.bubble_bux -= Game.UPGRADE_WORTH_COST
		$bubblemaker.upgrade_worth()
		Game.inc_value_cost($bubblemaker.worth)
		if $bubblemaker.worth >= Game.MAX_WORTH:
			value_upgrade.get_parent().modulate.a = 0
		value_upgrade.get_parent().get_node("Label").text = '-'+str(Game.UPGRADE_WORTH_COST)
