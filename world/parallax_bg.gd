extends Node2D


@export var _camera: Camera2D
@export var enabled: bool = true

var offset = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enabled:
		set_screen_offset(_camera.position.x + offset)


func set_screen_offset(val):
	for child in get_children():
		child.set_screen_offset(Vector2(val, 0))
	
