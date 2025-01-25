class_name Bubble
extends Node2D


@export var speed: float = 50.0

@onready var _sprite = get_node("Sprite2D")
@onready var anim_player = get_node("AnimationPlayer")

var velocity: Vector2 = Vector2.ZERO
var target = null
var direction: Vector2 = Vector2.ZERO
var bubble_id: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _physics_process(delta):
	if target != null:
		direction = position.direction_to(target.position)
		velocity = velocity.lerp(direction * speed, Game.ACCELERATION)
		if direction.x < 0:
			get_parent().set_flip_h(1)
		elif direction.x > 0:
			get_parent().set_flip_h(0)
	else:
		velocity = velocity.lerp(Vector2.ZERO, Game.FRICTION)
	position += velocity * delta
