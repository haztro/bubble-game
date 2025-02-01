extends Control

@export var _barracks: Barracks
@export var _bubble_maker: BubbleMaker
@export var _round_timer: Timer

@onready var _progress_bar = get_node("MarginContainer/VBoxContainer/ProgressBar")
@onready var _buy_small_btn = get_node("MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/buy_small")
@onready var _buy_med_btn = get_node("MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/buy_med")
@onready var _buy_large_btn = get_node("MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/buy_large")
@onready var _buy_upgrade_btn = get_node("MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer4/buy_upgrade")
@onready var _money_label = get_node("MarginContainer/TextureButton/Label")
@onready var _upgrade_label = get_node("MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer4/Label")
@onready var _speed_upgrade_btn = get_node("MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer5/speed_upgrade")
@onready var _value_upgrade_btn = get_node("MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer6/value_upgrade")
@onready var _btn_sound = get_node("btn_sound")
@onready var _buttons = get_node("MarginContainer/VBoxContainer/MarginContainer/HBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_ui_visible(true)
	if Game.barracks_tier >= 1:
		_buy_med_btn.get_parent().visible = true
	if Game.barracks_tier >= 2:
		_buy_large_btn.get_parent().visible = true
		_buy_upgrade_btn.get_parent().visible = false
	_upgrade_label.text = str(Game.BARRACKS_UPGRADE_COSTS[min(Game.barracks_tier, 1)])

	if Game.speed_tier >= Game.MAX_SPEED:
		_speed_upgrade_btn.get_parent().modulate.a = 0
	_speed_upgrade_btn.get_parent().get_node("Label").text = str(Game.UPGRADE_SPEED_COST)

	if Game.worth_tier >= Game.MAX_WORTH:
		_value_upgrade_btn.get_parent().modulate.a = 0
	_value_upgrade_btn.get_parent().get_node("Label").text = str(Game.UPGRADE_WORTH_COST)

	on_money_change()
	set_buy_btns_disabled(false)
	
func set_ui_visible(val):
	await show_buttons()
	_progress_bar.modulate.a = 1 if val else 0 
	_money_label.get_parent().modulate.a = 1 if val else 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_progress_bar.value = int(100 * (_round_timer.time_left / _round_timer.wait_time))
	#pass

func on_money_change():
	_money_label.text = str(Game.bubble_bux)
	_buy_upgrade_btn.disabled = !(Game.bubble_bux >= Game.BARRACKS_UPGRADE_COSTS[0])
	if Game.barracks_tier == 1:
		_buy_upgrade_btn.disabled = !(Game.bubble_bux >= Game.BARRACKS_UPGRADE_COSTS[1])
	_speed_upgrade_btn.disabled = (Game.bubble_bux < Game.UPGRADE_SPEED_COST or Game.speed_tier >= Game.MAX_SPEED)
	_value_upgrade_btn.disabled = (Game.bubble_bux < Game.UPGRADE_WORTH_COST or Game.worth_tier >= Game.MAX_WORTH)		
	
	print(_barracks.spawning)
	set_buy_btns_disabled(false)
	#_buy_small_btn.disabled = !(!_buy_small_btn.disabled and (Game.bubble_bux >= Game.UNIT_COSTS[Game.UNIT_TYPE.SMALL]))
	#_buy_med_btn.disabled = !(!_buy_med_btn.disabled and (Game.bubble_bux >= Game.UNIT_COSTS[Game.UNIT_TYPE.MEDIUM]))
	#_buy_large_btn.disabled = !(!_buy_large_btn.disabled and (Game.bubble_bux >= Game.UNIT_COSTS[Game.UNIT_TYPE.LARGE]))

func _on_speed_upgrade_pressed() -> void:
	_btn_sound.play()
	if Game.buy_speed_upgrade():
		_bubble_maker.upgrade()
		on_money_change()
		if Game.speed_tier >= Game.MAX_SPEED:
			_speed_upgrade_btn.get_parent().modulate.a = 0
		_speed_upgrade_btn.get_parent().get_node("Label").text = str(Game.UPGRADE_SPEED_COST)


func _on_value_upgrade_pressed() -> void:
	_btn_sound.play()
	if Game.buy_worth_upgrade():
		_bubble_maker.upgrade()
		on_money_change()
		if Game.worth_tier >= Game.MAX_WORTH:
			_value_upgrade_btn.get_parent().modulate.a = 0
		_value_upgrade_btn.get_parent().get_node("Label").text = str(Game.UPGRADE_WORTH_COST)


func _on_buy_upgrade_pressed() -> void:
	_btn_sound.play()
	if Game.buy_barracks_upgrade():
		on_money_change()
		if Game.barracks_tier == 1:
			_buy_med_btn.get_parent().visible = true
		elif Game.barracks_tier == 2:
			_buy_large_btn.get_parent().visible = true
			_buy_upgrade_btn.get_parent().visible = false
		_barracks.upgrade()
		_upgrade_label.text = str(Game.BARRACKS_UPGRADE_COSTS[min(Game.barracks_tier, 1)])


func _on_buy_small_pressed() -> void:
	_btn_sound.play()
	if Game.buy_bubble(Game.UNIT_TYPE.SMALL):
		_barracks.new_bubble(Game.UNIT_TYPE.SMALL)
		print(_barracks.spawning)
		on_money_change()
		set_buy_btns_disabled(true)
		
	

func _on_buy_med_pressed() -> void:
	_btn_sound.play()
	if Game.buy_bubble(Game.UNIT_TYPE.MEDIUM):
		_barracks.new_bubble(Game.UNIT_TYPE.MEDIUM)
		on_money_change()
		set_buy_btns_disabled(true)
		


func _on_buy_large_pressed() -> void:
	_btn_sound.play()
	if Game.buy_bubble(Game.UNIT_TYPE.LARGE):
		_barracks.new_bubble(Game.UNIT_TYPE.LARGE)
		on_money_change()
		set_buy_btns_disabled(true)
		

# buttons get enabled by barracks once spawn complete
func set_buy_btns_disabled(val: bool) -> void:
	if not val and not _barracks.spawning:
		_buy_small_btn.disabled = !(Game.bubble_bux >= Game.UNIT_COSTS[Game.UNIT_TYPE.SMALL])
		_buy_med_btn.disabled = !(Game.bubble_bux >= Game.UNIT_COSTS[Game.UNIT_TYPE.MEDIUM])
		_buy_large_btn.disabled = !(Game.bubble_bux >= Game.UNIT_COSTS[Game.UNIT_TYPE.LARGE])
	elif not val and _barracks.spawning:
		_buy_small_btn.disabled = true
		_buy_med_btn.disabled = true
		_buy_large_btn.disabled = true
	else:
		_buy_small_btn.disabled = val
		_buy_med_btn.disabled = val
		_buy_large_btn.disabled = val
		
		
func set_progress_bar_visible(val):
	_progress_bar.modulate.a = 1 if val else 0 
	_money_label.get_parent().modulate.a = 1 if val else 0
	

func hide_buttons():
	var tween = get_tree().create_tween()
	tween.tween_property(_buttons, "position:x", -192, 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	
func show_buttons():
	var tween1 = get_tree().create_tween()
	tween1.tween_property(_buttons, "position:x", -192, 0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(_buttons, "modulate:a", 1, 0)

	var tween = get_tree().create_tween()
	tween.tween_property(_buttons, "position:x", 0, 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
