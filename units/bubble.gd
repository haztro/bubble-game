class_name Bubble
extends CharacterBody2D


@export var speed: float = 50.0
@export var damage: float = 0.5
@export var is_enemy: bool = false

@onready var _sprite = get_node("Sprite2D")
@onready var _fsm = get_node("state_machine")
@onready var anim_player = get_node("AnimationPlayer")

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
		modulate = Color.RED
	else:
		add_to_group("human")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _physics_process(delta):
	if target != null:
		if _fsm._state_name == "StateMove":
			destination = target.position
			destination.x += Game.ATTACK_DISTANCE * (-1 if position.x < target.position.x else 1)
			direction = position.direction_to(destination)
			velocity = velocity.lerp(direction * speed, Game.ACCELERATION)
			_sprite.set_flip_h(1 if position > target.position else 0)
		else:
			velocity = Vector2.ZERO #velocity.lerp(Vector2.ZERO, 0)
	else:
		velocity = Vector2.ZERO #velocity.lerp(Vector2.ZERO, 0)
			
	move_and_slide()
	

func die():
	_fsm.set_process_mode(Node.PROCESS_MODE_DISABLED)
	anim_player.play("death")
	await anim_player.animation_finished
	queue_free()
	
	
func attack():
	if target != null:
		target.health -= damage
		if target.health <= 0:
			target.die()
