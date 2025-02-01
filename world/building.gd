extends Node2D


@export var init_position: Vector2
@onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var _audio_player: AudioStreamPlayer = get_node("AudioStreamPlayer")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func upgrade():
	pass
