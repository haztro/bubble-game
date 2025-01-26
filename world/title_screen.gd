extends Control

signal finished

@export var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position", Vector2(camera.position.x + 384, camera.position.y), 2.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	$Timer.start()


func _on_timer_timeout() -> void:
	emit_signal("finished")
