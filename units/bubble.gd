class_name Bubble
extends CharacterBody2D


@export var speed: float = 50.0
@export var damage: float = 1
@export var is_enemy: bool = false

@onready var _sprite = get_node("Sprite2D")
@onready var _fsm = get_node("state_machine")
@onready var anim_player = get_node("AnimationPlayer")
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
@onready var _death_sound: AudioStreamPlayer = get_node("death_sound")
@onready var _scream_sound: AudioStreamPlayer = get_node("scream_sound")
@onready var _scream_timer: Timer = get_node("Timer")

var _enemy_textures = [
	preload("res://assets/characters/enemy/bubble-enemy-small-Sheet.png"),
	preload("res://assets/characters/enemy/bubble-enemy-medium-Sheet.png"),
	preload("res://assets/characters/enemy/bubble-enemy-big-Sheet.png"),
]


var run_speed = 150
@export var health = 1.0

@export var data: UnitData = UnitData.new()


var target = null
var destination: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var bubble_id: int = 0

var split = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_enemy:
		add_to_group("enemy")
		_sprite.texture = _enemy_textures[data.unit_type]
		if split:
			_fsm.set_state("StateSearch")
	else:
		add_to_group("human")
		_scream_timer.wait_time = randf_range(0.5, 2)
		_fsm.set_state("StateSearch")
		if not split:
			_sprite.frame = 24
			_fsm.set_process_mode(Node.PROCESS_MODE_DISABLED)
		
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	

func run_to_next():
	if health <= 0: return # if called during animation need to ignore cause dead
	if Game.game_state == Game.GAME_STATE.FIGHT:
		destination = Vector2(randi_range(192, 384), randi_range(75, 190)) + Vector2(384+192, 0)
	_fsm.set_state("StateRun")	
	
	
func start_battle():
	_scream_timer.start()
	_fsm.set_state("StateSearch")

	
func spawn_self():
	anim_player.play("spawn")
	await anim_player.animation_finished
	_fsm.set_process_mode(Node.PROCESS_MODE_INHERIT)
	if Game.game_state == Game.GAME_STATE.FIGHT:
		_fsm.set_state("StateSearch")
	else:
		_fsm.set_state("StateIdle")
		
		
func set_body_direction():
	# if there's an enemy then go to its position otherwise just
	# run to destination
	if position.x > (destination.x if target == null else target.position.x):
		_sprite.set_flip_h(1)
		$CollisionShape2D.position.x = 3
	else:
		_sprite.set_flip_h(0)
		$CollisionShape2D.position.x = -3
	
	
func _physics_process(delta):
	var current_speed = run_speed if target == null else speed
	var should_move = (target == null and _fsm._state_name == "StateRun") or \
						(target != null and _fsm._state_name == "StateMove")

	if should_move:
		direction = position.direction_to(destination)
		velocity = velocity.lerp(direction * current_speed, Game.ACCELERATION)
		set_body_direction()
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	data.position = position
	
	
func set_sword_direction():
	pass
	
	
func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
	

func die():
	_fsm.set_process_mode(Node.PROCESS_MODE_DISABLED)
	anim_player.stop
	anim_player.play("death")
	var offset = position + Vector2(randi_range(-3, 3), randf_range(-3, 3))

	_death_sound.play()

	match data.unit_type:
		Game.UNIT_TYPE.SMALL:
			pass
		Game.UNIT_TYPE.MEDIUM:
			for i in range(2): get_parent().spawn_bubble(offset, Game.UNIT_TYPE.SMALL, is_in_group("enemy"))
		Game.UNIT_TYPE.LARGE:
			for i in range(2): get_parent().spawn_bubble(offset*-1 , Game.UNIT_TYPE.MEDIUM, is_in_group("enemy"))
		
	await anim_player.animation_finished
	remove_from_group("enemy" if is_in_group("enemy") else "human")
	get_parent().check_win()
	get_parent().remove_child(self)
	queue_free()
	
	
func attack():
	if target != null and target.health > 0:
		target.health -= damage
		if target.health <= 0:
			target.die()


func _on_timer_timeout() -> void:
	if randf() <= 0.8:
		_scream_sound.play()
