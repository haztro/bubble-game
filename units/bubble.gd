class_name Bubble
extends CharacterBody2D


@export var speed: float = 50.0
@export var damage: float = 1
@export_enum('small', 'medium', 'large') var bubble_size = 'small'
@export var is_enemy: bool = false

@onready var _sprite = get_node("Sprite2D")
@onready var _fsm = get_node("state_machine")
@onready var anim_player = get_node("AnimationPlayer")
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")

var health = 1.0

#var velocity: Vector2 = Vector2.ZERO
var target = null
var destination: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var bubble_id: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_enemy:
		add_to_group("enemy")
		if bubble_size == 'small':
			_sprite.texture = load("res://assets/characters/enemy/bubble-enemy-small-Sheet.png")
		elif bubble_size == 'medium':
			_sprite.texture = load("res://assets/characters/enemy/bubble-enemy-medium-Sheet.png")
		elif bubble_size == 'large':
			_sprite.texture = load("res://assets/characters/enemy/bubble-enemy-large-Sheet.png")
		#modulate = Color.RED
	else:
		add_to_group("human")
		_sprite.frame = 24
		_fsm.set_process_mode(Node.PROCESS_MODE_DISABLED)
		
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	

func run_to_next():
	print("RUNNING")
	if Game.mode == "battle":
		destination = Vector2(randi_range(0, 100), randi_range(75, 190)) + Vector2(384 * Game.level, 0)
	_fsm.set_state("StateRun")	
	
	
func start_battle():
	_fsm.set_state("StateSearch")

	
func spawn_self():
	anim_player.play("spawn")
	await anim_player.animation_finished
	_fsm.set_process_mode(Node.PROCESS_MODE_INHERIT)
	if Game.mode == "battle":
		_fsm.set_state("Search")
	else:
		_fsm.set_state("StateIdle")
	
	
func _physics_process(delta):
	if target != null:
		if _fsm._state_name == "StateMove":
			destination = target.position
			destination.x += Game.ATTACK_DISTANCE * (-1 if position.x < target.position.x else 1)
			direction = position.direction_to(destination)
			velocity = velocity.lerp(direction * speed, Game.ACCELERATION)
			if position.x > target.position.x:
				_sprite.set_flip_h(1)
				$CollisionShape2D.position.x = 3
			else:
				_sprite.set_flip_h(0)
				$CollisionShape2D.position.x = -3
		else:
			velocity = Vector2.ZERO #velocity.lerp(Vector2.ZERO, 0)
	else:
		if _fsm._state_name == "StateRun":
			print(destination)
			direction = position.direction_to(destination)
			velocity = velocity.lerp(direction * speed, Game.ACCELERATION)
			if position.x > destination.x:
				_sprite.set_flip_h(1)
				$CollisionShape2D.position.x = 3
			else:
				_sprite.set_flip_h(0)
				$CollisionShape2D.position.x = -3
		else:
			velocity = Vector2.ZERO #velocity.lerp(Vector2.ZERO, 0)
			
	#navigation_agent.set_velocity(velocity)
	move_and_slide()
	
	
func set_sword_direction():
	pass
	
	
func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
	

func die():
	_fsm.set_process_mode(Node.PROCESS_MODE_DISABLED)
	anim_player.stop
	anim_player.play("death")
	var offset1 = position + Vector2(randi_range(-3, 3), randf_range(-3, 3))
	var offset2 = position + Vector2(randi_range(-3, 3), randf_range(-3, 3))
	
	match bubble_size:
		'small':
			pass
		'medium':
			get_tree().get_first_node_in_group("world").spawn_bubble(offset1 , "small", is_in_group("enemy"))
			get_tree().get_first_node_in_group("world").spawn_bubble(offset2, "small", is_in_group("enemy"))
		'large':
			get_tree().get_first_node_in_group("world").spawn_bubble(offset1, "medium", is_in_group("enemy"))
			get_tree().get_first_node_in_group("world").spawn_bubble(offset2, "medium", is_in_group("enemy"))
		
	await anim_player.animation_finished
	queue_free()
	
	
func attack():
	if target != null and target.health > 0:
		target.health -= damage
		if target.health <= 0:
			target.die()


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	#print(is_enemy, anim_name)
	pass
