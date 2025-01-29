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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_progress_bar.value = int(100 * (_round_timer.time_left / _round_timer.wait_time))


func on_money_change():
	_money_label.text = str(Game.bubble_bux)
	_buy_upgrade_btn.disabled = !(Game.bubble_bux >= Game.BARRACKS_UPGRADE_COSTS[0])
	_buy_upgrade_btn.disabled = !(Game.bubble_bux >= Game.BARRACKS_UPGRADE_COSTS[1])
	_speed_upgrade_btn.disabled = (Game.bubble_bux < Game.UPGRADE_SPEED_COST or _bubble_maker.tier >= Game.MAX_SPEED)
	_value_upgrade_btn.disabled = (Game.bubble_bux < Game.UPGRADE_WORTH_COST or _bubble_maker.worth >= Game.MAX_WORTH)
		
		

func _on_speed_upgrade_pressed() -> void:
	_btn_sound.play()
	if Game.buy_speed_upgrade(_bubble_maker.tier):
		_bubble_maker.upgrade()
		on_money_change()
		if _bubble_maker.tier >= Game.MAX_SPEED:
			_speed_upgrade_btn.get_parent().modulate.a = 0
		_speed_upgrade_btn.get_parent().get_node("Label").text = str(Game.UPGRADE_SPEED_COST)


func _on_value_upgrade_pressed() -> void:
	_btn_sound.play()
	if Game.buy_worth_upgrade(_bubble_maker.tier):
		_bubble_maker.upgrade_worth()
		on_money_change()
		if _bubble_maker.worth >= Game.MAX_WORTH:
			_value_upgrade_btn.get_parent().modulate.a = 0
		_value_upgrade_btn.get_parent().get_node("Label").text = '-'+str(Game.UPGRADE_WORTH_COST)


func _on_buy_upgrade_pressed() -> void:
	_btn_sound.play()
	if Game.buy_barracks_upgrade(_barracks.tier):
		on_money_change()
		if _barracks.tier == 0:
			_buy_med_btn.get_parent().visible = true
		elif _barracks.tier == 1:
			_buy_large_btn.get_parent().visible = true
			_buy_upgrade_btn.get_parent().visible = false
		_barracks.upgrade()
		_upgrade_label.text = str(Game.BARRACKS_UPGRADE_COSTS[min(_barracks.tier, 1)])


func _on_buy_small_pressed() -> void:
	_btn_sound.play()
	if Game.buy_bubble(Game.UNIT_TYPE.SMALL):
		on_money_change()
		set_buy_btns_disabled(true)
		_barracks.new_bubble(Game.UNIT_TYPE.SMALL)
	

func _on_buy_med_pressed() -> void:
	_btn_sound.play()
	if Game.buy_bubble(Game.UNIT_TYPE.MEDIUM):
		on_money_change()
		set_buy_btns_disabled(true)
		_barracks.new_bubble(Game.UNIT_TYPE.MEDIUM)


func _on_buy_large_pressed() -> void:
	_btn_sound.play()
	if Game.buy_bubble(Game.UNIT_TYPE.LARGE):
		on_money_change()
		set_buy_btns_disabled(true)
		_barracks.new_bubble(Game.UNIT_TYPE.LARGE)
		
	
# buttons get enabled by barracks once spawn complete
func set_buy_btns_disabled(val: bool) -> void:
	if not val and not _barracks.spawning:
		_buy_small_btn.disabled = !(Game.bubble_bux >= Game.UNIT_COSTS[Game.UNIT_TYPE.SMALL])
		_buy_med_btn.disabled = !(Game.bubble_bux >= Game.UNIT_COSTS[Game.UNIT_TYPE.MEDIUM])
		_buy_large_btn.disabled = !(Game.bubble_bux >= Game.UNIT_COSTS[Game.UNIT_TYPE.LARGE])
	else:
		_buy_small_btn.disabled = val
		_buy_med_btn.disabled = val
		_buy_large_btn.disabled = val
		
		
func set_progress_bar_visible(val):
	_progress_bar.modulate.a = 1 if val else 0 
	

func hide_buttons():
	var tween = get_tree().create_tween()
	tween.tween_property(_buttons, "position", Vector2(-192, _buttons.position.y), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	
func show_buttons():
	print(_buttons.position)
	_buttons.position.x = -192
	var tween = get_tree().create_tween()
	tween.tween_property(_buttons, "position", Vector2(0, _buttons.position.y), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
